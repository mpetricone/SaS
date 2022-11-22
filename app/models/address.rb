class Address < ActiveRecord::Base
    validates :street1, presence: true
    validates :city, presence: true
    validates :postal_code, presence: true, length: {minimum: 5 }
    has_many :ou_addresses
    has_many :ou, through: :ou_addresses
    has_many :address_contacts
    has_many :address_clients
    has_many :default_invoice_addresses, class_name: 'Client', foreign_key: :default_invoice_id
    has_many :default_delivery_addresses, class_name: 'Client', foreign_key: :default_delivery_id
    has_many :ticket_invoice_addresses, class_name: 'Ticket', foreign_key: :default_invoice_id
    has_many :ticket_delivery_addresses, class_name: 'Ticket', foreign_key: :default_delivery_id
    has_many :ticket_ou_addresses, class_name: 'Ticket', foreign_key: :ou_address_id
    
    def name_long
        "#{street1}, #{street2}, #{city}, #{state}, #{postal_code}"
    end

    def name_short
        "#{street1}, #{city}"
    end
    # country and always street2
    def formal_full_out
        "#{street1}\n#{street2}\n#{city},#{state} #{postal_code}\n#{country}"
    end
    # no country, no empty street 2, unless international, this is probably what your looking for
    def formal_out html=false
        if html
            nl = '<br />'.html_safe
        else 
            nl = "\n"
        end
        out = "#{street1} #{nl}".html_safe
        if street2 && street2!=""
            out += "#{street2} #{nl}".html_safe
        end
        out += "#{city}, #{state} #{postal_code}".html_safe
    end
end
