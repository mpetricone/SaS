class Ou < ActiveRecord::Base
    has_many :ou_addresses, dependent: :destroy
    has_many :addresses, through: :ou_addresses
    has_many :ou_phones, dependent: :destroy
    has_many :ou_emails, dependent: :destroy
    has_many :employees, dependent: :destroy
    has_many :roots, class_name: "Ou", foreign_key: "root_id"
    has_many :tickets
    belongs_to :root, class_name: "Ou", optional: true
    belongs_to :tax
    accepts_nested_attributes_for :ou_emails, :ou_phones, :ou_addresses, :roots
    validates :name , :presence => true
end
