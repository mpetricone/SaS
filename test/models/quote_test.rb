require "test_helper"

class QuoteTest < ActiveSupport::TestCase
  def fresh_quote(**overrides)
    Quote.create!({
      client: clients(:client_0),
      ou:     ous(:ou_0),
      rate:   rates(:rate_0),
      employee: employees(:admin),
      title: 'fresh',
      status: :draft
    }.merge(overrides))
  end

  test "editable? true for draft and sent only" do
    q = fresh_quote
    assert q.editable?
    q.send_to_client!
    assert q.editable?
    q.accept!
    assert_not q.editable?
  end

  test "calculate_totals handles products only" do
    q = fresh_quote
    q.quote_products.create!(product: products(:product_0), price: '10.00', quantity: 3)
    t = q.calculate_totals
    assert_equal 30.0, t[:product]
    assert_equal 0.0,  t[:labor]
    assert_equal 30.0, t[:grand]
  end

  test "calculate_totals handles fixed and hourly labor" do
    q = fresh_quote
    q.quote_labors.create!(description: 'fixed', billing: :fixed, amount: '100.00')
    q.quote_labors.create!(description: 'hourly', billing: :hourly, rate: rates(:rate_0), estimated_hours: 2.0)
    expected_hourly = (2.0 * rates(:rate_0).rate.to_f).round(2)
    t = q.calculate_totals
    assert_in_delta 100.0 + expected_hourly, t[:labor], 0.01
  end

  test "calculate_totals applies tax on product, plus labor when taxable_labor" do
    q = fresh_quote(taxable: true, tax_rate: 0.1, taxable_labor: true)
    q.quote_products.create!(product: products(:product_0), price: '100.00', quantity: 1)
    q.quote_labors.create!(description: 'fixed', billing: :fixed, amount: '50.00')
    t = q.calculate_totals
    assert_in_delta 15.0,  t[:tax], 0.01  # 100*.1 + 50*.1
    assert_in_delta 165.0, t[:grand], 0.01
  end

  test "convert_to_ticket requires accepted" do
    q = fresh_quote
    assert_raises(RuntimeError) { q.convert_to_ticket! }
  end

  test "convert_to_ticket builds Ticket and ProductTickets" do
    q = fresh_quote
    q.quote_products.create!(product: products(:product_0), price: '10.00', quantity: 2)
    q.quote_labors.create!(description: 'fixed', billing: :fixed, amount: '50.00')
    q.send_to_client!
    q.accept!

    assert_difference -> { Ticket.count }, 1 do
      assert_difference -> { ProductTicket.count }, 1 do
        q.convert_to_ticket!
      end
    end
    q.reload
    assert q.completed?
    assert q.converted_ticket_id.present?
    ticket = q.converted_ticket
    assert_equal '50.0', ticket.billing_fixed_value
    assert ticket.billing_fixed
  end

  test "convert_to_ticket copies client default invoice and delivery addresses to the new ticket" do
    q = fresh_quote
    q.quote_products.create!(product: products(:product_0), price: '10.00', quantity: 1)
    q.send_to_client!; q.accept!
    q.convert_to_ticket!
    ticket = q.reload.converted_ticket
    assert_equal q.client.default_invoice_id,  ticket.default_invoice_id
    assert_equal q.client.default_delivery_id, ticket.default_delivery_id
  end

  test "convert_to_ticket falls back to a current rate when the quote has none" do
    q = fresh_quote(rate: nil)
    q.quote_products.create!(product: products(:product_0), price: '10.00', quantity: 1)
    q.send_to_client!; q.accept!
    q.convert_to_ticket!
    ticket = q.reload.converted_ticket
    assert ticket.rate_id.present?, 'ticket should pick up a fallback rate'
  end

  test "convert_to_ticket refuses if already converted" do
    q = fresh_quote
    q.send_to_client!
    q.accept!
    q.convert_to_ticket!
    assert_raises(RuntimeError) { q.convert_to_ticket! }
  end

  test "locked quote rejects line item mutation" do
    q = fresh_quote
    q.send_to_client!
    q.accept!
    qp = QuoteProduct.new(quote: q, product: products(:product_0), price: '10', quantity: 1)
    assert_not qp.save
    assert_includes qp.errors.full_messages.to_sentence, 'locked'
  end

  test "addendum builds with parent metadata copied" do
    parent = fresh_quote(taxable: true, tax_rate: 0.05, taxable_labor: true)
    parent.send_to_client!
    parent.accept!
    add = parent.build_addendum
    assert_equal parent.id,        add.parent_quote_id
    assert_equal parent.client_id, add.client_id
    assert_equal parent.tax_rate,  add.tax_rate
    assert add.draft?
  end

  test "addendum convert appends to parent's ticket" do
    parent = fresh_quote
    parent.quote_products.create!(product: products(:product_0), price: '10.00', quantity: 1)
    parent.quote_labors.create!(description: 'fixed', billing: :fixed, amount: '20.00')
    parent.send_to_client!; parent.accept!; parent.convert_to_ticket!
    parent.reload
    parent_ticket = parent.converted_ticket
    parent_ticket_id = parent_ticket.id

    add = parent.build_addendum
    add.save!
    add.quote_products.create!(product: products(:product_1), price: '5.00', quantity: 2)
    add.quote_labors.create!(description: 'more fixed', billing: :fixed, amount: '15.00')
    add.send_to_client!; add.accept!

    assert_no_difference -> { Ticket.count } do
      add.convert_to_ticket!
    end
    add.reload
    assert_equal parent_ticket_id, add.converted_ticket_id
    parent_ticket.reload
    assert_equal '35.0', parent_ticket.billing_fixed_value # 20 + 15
    assert_equal 2, parent_ticket.product_tickets.count
  end

  test "all_associated_tickets returns parent + addenda tickets deduped" do
    parent = fresh_quote
    parent.send_to_client!; parent.accept!; parent.convert_to_ticket!
    parent.reload
    add = parent.build_addendum; add.save!
    add.send_to_client!; add.accept!; add.convert_to_ticket!
    parent.reload
    assert_equal 1, parent.all_associated_tickets.count
  end

  test "code is generated on create matching Q<days>-<6 alphanumeric>" do
    q = fresh_quote
    assert_match(/\AQ\d+-[A-Z0-9]{6}\z/, q.code)
  end

  test "code is preserved across saves" do
    q = fresh_quote
    original = q.code
    q.update!(title: 'renamed')
    assert_equal original, q.reload.code
  end

  test "code passed explicitly at create is preserved" do
    q = fresh_quote(code: 'Q99999-OVERRD')
    assert_equal 'Q99999-OVERRD', q.code
  end

  test "default expires_at is set to ~2 weeks from now on create" do
    q = fresh_quote
    assert q.expires_at.present?
    assert_in_delta (Time.current + 2.weeks).to_i, q.expires_at.to_i, 5
  end

  test "explicit expires_at on create is preserved" do
    target = Time.current + 30.days
    q = fresh_quote(expires_at: target)
    assert_in_delta target.to_i, q.expires_at.to_i, 1
  end

  test "expire_if_past_due! flips draft past expiration to expired" do
    q = fresh_quote(expires_at: 1.day.ago)
    assert q.expire_if_past_due!
    assert q.reload.expired?
  end

  test "expire_if_past_due! flips sent past expiration to expired" do
    q = fresh_quote(expires_at: 1.day.ago)
    q.update_columns(status: Quote.statuses[:sent], sent_at: 2.days.ago)
    assert q.expire_if_past_due!
    assert q.reload.expired?
  end

  test "expire_if_past_due! is a no-op when not past due" do
    q = fresh_quote(expires_at: 1.week.from_now)
    assert_not q.expire_if_past_due!
    assert q.reload.draft?
  end

  test "expire_if_past_due! does not touch accepted or declined quotes" do
    q = fresh_quote(expires_at: 1.day.ago)
    q.send_to_client!; q.accept!
    assert_not q.expire_if_past_due!
    assert q.reload.accepted?
  end

  test "expired quote is not editable" do
    q = fresh_quote(expires_at: 1.day.ago)
    q.expire_if_past_due!
    assert_not q.editable?
  end

  test "Quote.expire_due! bulk-flips past-due draft and sent only" do
    past_draft  = fresh_quote(expires_at: 2.days.ago)
    past_sent   = fresh_quote(expires_at: 2.days.ago)
    past_sent.update_columns(status: Quote.statuses[:sent], sent_at: 3.days.ago)
    future_draft = fresh_quote(expires_at: 1.week.from_now)
    accepted = fresh_quote(expires_at: 2.days.ago)
    accepted.send_to_client!; accepted.accept!

    count = Quote.expire_due!
    assert_equal 2, count
    assert past_draft.reload.expired?
    assert past_sent.reload.expired?
    assert future_draft.reload.draft?
    assert accepted.reload.accepted?
  end

  test "resolved_payment_terms prefers override when present" do
    q = fresh_quote(payment_term: payment_terms(:paid_on_completion), payment_terms_override: 'Custom: net 7')
    assert_equal 'Custom: net 7', q.resolved_payment_terms
  end

  test "resolved_payment_terms falls back to the term description, then name" do
    q1 = fresh_quote(payment_term: payment_terms(:paid_on_completion))
    assert_equal payment_terms(:paid_on_completion).description, q1.resolved_payment_terms

    described_blank = PaymentTerm.create!(name: 'Bare term')
    q2 = fresh_quote(payment_term: described_blank)
    assert_equal 'Bare term', q2.resolved_payment_terms
  end

  test "resolved_payment_terms is nil when nothing is set" do
    q = fresh_quote
    assert_nil q.resolved_payment_terms
  end

  test "Ticket#originating_quotes returns all quotes pointing at it" do
    parent = fresh_quote
    parent.send_to_client!; parent.accept!; parent.convert_to_ticket!
    parent.reload
    add = parent.build_addendum; add.save!
    add.send_to_client!; add.accept!; add.convert_to_ticket!
    parent.reload
    ticket = parent.converted_ticket
    assert_equal [parent.id, add.id].sort, ticket.originating_quotes.pluck(:id).sort
  end
end
