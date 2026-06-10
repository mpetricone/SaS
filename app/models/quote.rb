class Quote < ApplicationRecord
  belongs_to :client
  belongs_to :contact,          optional: true
  belongs_to :ou
  belongs_to :rate,             optional: true
  belongs_to :employee,         optional: true
  belongs_to :converted_ticket, class_name: 'Ticket', optional: true
  belongs_to :parent_quote,     class_name: 'Quote',  optional: true
  belongs_to :payment_term,     optional: true
  has_many   :addenda,          class_name: 'Quote',  foreign_key: 'parent_quote_id', dependent: :nullify
  has_many   :quote_products, dependent: :destroy
  has_many   :quote_labors,   dependent: :destroy
  has_many   :products, through: :quote_products

  enum :status, { draft: 0, sent: 1, accepted: 2, declined: 3, completed: 4, expired: 5 }

  validates :client_id, :ou_id, :status, presence: true
  validates :code, uniqueness: true, allow_nil: true

  before_validation :set_default_expires_at, on: :create
  before_validation :generate_code, on: :create

  scope :awaiting_response, -> { where(status: [statuses[:draft], statuses[:sent]]) }

  def addendum?
    parent_quote_id.present?
  end

  def editable?
    draft? || sent?
  end

  def resolved_payment_terms
    return payment_terms_override if payment_terms_override.present?
    payment_term&.description.presence || payment_term&.name
  end

  def past_due?(at: Time.current)
    expires_at.present? && expires_at <= at
  end

  def expire_if_past_due!(at: Time.current)
    return false unless (draft? || sent?) && past_due?(at: at)
    update!(status: :expired)
    true
  end

  def self.expire_due!(at: Time.current)
    awaiting_response.where("expires_at <= ?", at)
                     .update_all(status: statuses[:expired], updated_at: Time.current)
  end

  def all_associated_tickets
    ids = [converted_ticket_id, *addenda.pluck(:converted_ticket_id)].compact.uniq
    Ticket.where(id: ids)
  end

  def calculate_totals
    product = quote_products.sum { |p| p.price.to_f * p.quantity.to_i }
    labor   = quote_labors.sum(&:line_total)
    sub     = (product + labor).round(2)
    tax     = 0.0
    if taxable
      tax += tax_rate.to_f * product
      tax += tax_rate.to_f * labor if taxable_labor
    end
    tax = tax.round(2)
    { product: product.round(2), labor: labor.round(2), sub: sub, tax: tax, grand: (sub + tax).round(2) }
  end

  def send_to_client!
    update!(status: :sent, sent_at: Time.current)
  end

  def accept!
    update!(status: :accepted, accepted_at: Time.current)
  end

  def decline!
    update!(status: :declined, declined_at: Time.current)
  end

  def build_addendum(employee: nil)
    Quote.new(
      parent_quote_id: id,
      client_id:       client_id,
      contact_id:      contact_id,
      ou_id:           ou_id,
      rate_id:         rate_id,
      taxable:         taxable,
      taxable_labor:   taxable_labor,
      tax_rate:        tax_rate,
      employee_id:     employee&.id,
      title:           "Addendum to #{title}",
      status:          :draft
    )
  end

  def convert_to_ticket!
    raise 'Quote must be accepted' unless accepted?
    raise 'Already converted'      if converted_ticket_id.present?

    transaction do
      fixed_total  = quote_labors.fixed.sum { |l| l.amount.to_f }
      hourly_lines = quote_labors.hourly.to_a
      target_ticket = parent_quote&.converted_ticket

      ticket =
        if target_ticket
          append_to_ticket!(target_ticket, fixed_total, hourly_lines)
          target_ticket
        else
          ticket_contact_id  = contact_id  || client.contacts.first&.id
          ticket_employee_id = employee_id || Employee.first&.id
          ticket_rate_id     = hourly_lines.first&.rate_id ||
                               rate_id ||
                               client.client_rates.find_by(current: true)&.rate_id ||
                               Rate.where(current: true).first&.id
          raise 'No rate available for ticket conversion. Set a rate on the quote, add an hourly labor line, or configure a current rate.' if ticket_rate_id.nil?
          new_ticket = Ticket.create!(
            client_id:           client_id,
            contact_id:          ticket_contact_id,
            employee_id:         ticket_employee_id,
            ou_id:               ou_id,
            rate_id:             ticket_rate_id,
            ticket_status_id:    TicketStatus.find_by(name: TicketStatus::ACTIVE)&.id,
            billing_fixed:       fixed_total > 0,
            billing_fixed_value: fixed_total > 0 ? fixed_total.to_s : nil,
            billing_hourly:      hourly_lines.any?,
            taxable:             taxable,
            taxable_labor:       taxable_labor,
            tax_rate:            tax_rate,
            short_description:   title,
            default_invoice_id:  client.default_invoice_id,
            default_delivery_id: client.default_delivery_id
          )
          quote_products.each do |qp|
            new_ticket.product_tickets.create!(product_id: qp.product_id, price: qp.price, quantity: qp.quantity)
          end
          new_ticket
        end

      update!(status: :completed, completed_at: Time.current, converted_ticket_id: ticket.id)
      ticket
    end
  end

  private

  def set_default_expires_at
    self.expires_at ||= (created_at || Time.current) + 2.weeks
  end

  def generate_code
    return if code.present?
    day = ((created_at || Time.current).to_date - Date.new(1970, 1, 1)).to_i
    10.times do
      candidate = "Q#{day}-#{SecureRandom.alphanumeric(6).upcase}"
      unless Quote.exists?(code: candidate)
        self.code = candidate
        return
      end
    end
    raise "Failed to generate unique quote code after 10 attempts"
  end

  def append_to_ticket!(ticket, fixed_total, hourly_lines)
    quote_products.each do |qp|
      ticket.product_tickets.create!(product_id: qp.product_id, price: qp.price, quantity: qp.quantity)
    end
    new_fixed_total = ticket.billing_fixed_value.to_f + fixed_total
    ticket.update!(
      billing_fixed:       new_fixed_total > 0 || ticket.billing_fixed,
      billing_fixed_value: new_fixed_total > 0 ? new_fixed_total.to_s : ticket.billing_fixed_value,
      billing_hourly:      ticket.billing_hourly || hourly_lines.any?,
      rate_id:             ticket.rate_id || hourly_lines.first&.rate_id
    )
  end
end
