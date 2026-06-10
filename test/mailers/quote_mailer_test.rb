require 'test_helper'

class QuoteMailerTest < ActionMailer::TestCase
  test "quote_proposal builds an email for one or many recipients" do
    quote = quotes(:draft_quote)
    mail  = QuoteMailer.quote_proposal(quote, ['one@example.com', 'two@example.com'])
    assert_equal ['one@example.com', 'two@example.com'], mail.to
    assert_match(/Quote #{Regexp.escape(quote.code)}/, mail.subject)
    assert_match(/#{quote.client.name}/, mail.body.encoded)
  end

  test "quote_proposal body includes the quote code, prepared-by, and Products totals line" do
    quote = quotes(:draft_quote)
    quote.quote_products.create!(product: products(:product_0), price: '10.00', quantity: 1)
    mail = QuoteMailer.quote_proposal(quote, ['x@example.com'])
    body = mail.body.encoded
    assert_match(/#{Regexp.escape(quote.code)}/, body)
    assert_match(/Prepared by/, body) if quote.employee.present?
    assert_match(/Products:/, body)
  end

  test "quote_proposal includes resolved payment terms when set" do
    quote = quotes(:draft_quote)
    quote.update!(payment_term: payment_terms(:paid_on_completion))
    mail = QuoteMailer.quote_proposal(quote, ['x@example.com'])
    assert_match(/Payment Terms/, mail.body.encoded)
    assert_match(/Payment in full is due upon completion/, mail.body.encoded)
  end
end
