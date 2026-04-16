class Distributer < ActiveRecord::Base
    has_many :address_distributers, dependent: :destroy
    has_many :addresses, through: :address_distributers
    has_many :contact_distributers, dependent: :destroy
    has_many :contacts, through: :contact_distributers
    has_many :distributer_phones, dependent: :destroy
    has_many :distributer_emails, dependent: :destroy
    accepts_nested_attributes_for :address_distributers
    accepts_nested_attributes_for :contact_distributers
    accepts_nested_attributes_for :distributer_phones
    accepts_nested_attributes_for :distributer_emails 
    validates :name, presence: true
end
