class Client < ActiveRecord::Base
  belongs_to :standing
  belongs_to :default_invoice_address, class_name: "Address", foreign_key: "default_invoice_id", optional: true
  belongs_to :default_delivery_address, class_name: "Address", foreign_key: "default_delivery_id", optional: true
  has_many :client_phones, dependent: :destroy
  has_many :client_emails, dependent: :destroy
  has_many :address_clients, dependent: :delete_all
  has_many :addresses, through: :address_clients
  has_many :client_notes, dependent: :destroy
  has_many :client_contacts, dependent: :destroy
  has_many :contacts, through: :client_contacts
  has_many :client_rates, dependent: :destroy
  has_many :rates , through: :client_rates
  has_many :tickets
  accepts_nested_attributes_for :client_phones
  accepts_nested_attributes_for :client_emails
  accepts_nested_attributes_for :client_contacts
  accepts_nested_attributes_for :address_clients
  accepts_nested_attributes_for :client_rates
  validates :name, presence: true
  validates :address_clients, presence: true
  validates :client_phones, presence: true

  def has_address_defaults?
    return default_invoice_address && default_delivery_address
  end

  def has_all_address_types?
    return has_delivery_address? && has_invoice_address?
  end

  def has_delivery_address?
    return !address_clients.where(delivery: true).empty?
  end

  def has_invoice_address?
    return !address_clients.where(invoice: true).empty?
  end

  #create address deliverable defaults, guessing if necessary
  #returns true on success or no action taken
  #returns false on failure or no addresses
  def create_address_deliverables
    if addresses.empty?
      return false
    end

    if !has_invoice_address?
      if default_invoice_address
        invoice = address_clients.where(address_id: default_invoice_address).first
        invoice.invoice = true
        invoice.save
      else
        address_clients.first.invoice = true
        address_clients.first.save
      end
    end

    if !has_delivery_address?
      if default_delivery_address
        delivery = address_clients.where(address_id: default_delivery_address).first
        delivery.delivery = true
        delivery.save
      else
        address_clients.first.delivery = true
        address_clients.first.save
      end
    end

    return has_all_address_types?
  end

  #create address defaults if none exist
  def create_address_defaults
    if addresses.empty?
      return
    end

    if !default_invoice_address
      if has_invoice_address?
        default_invoice_address = address_clients.where(invoice: true).first.address
      else
        default_invoice_address = address_clients.first.address
      end
    end

    if !default_delivery_address
      if has_delivery_address?
        default_delivery_address = address_clients.where(delivery: true).first.address
      else
        default_delivery_address = address_clients.first.address
      end
    end

    update default_delivery_address: default_delivery_address, default_invoice_address: default_invoice_address
  end

  def enforce_address_compatibility
    if default_invoice_id==nil
      create_address_defaults
    end

    if default_invoice_id==nil
      create_address_deliverables
    end
  end

  def accounts_receivable start_date, end_date
    rv = []
    tar = 0.0
    gt = 0.0
    tickets.where('invoice_date >= ? AND invoice_date <= ?', start_date, end_date).each do |t|
      total = t.calculate_totals
      if !t.paid_in_full?( total) && total[:error]==0
        tar += total[:outstanding]
        gt += total[:grand]
        rv.push( { ticket: t, totals: total })
      end
    end

    return { accounts: rv, total: tar, grand_total: gt }
  end
end
