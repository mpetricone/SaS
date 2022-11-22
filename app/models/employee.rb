class Employee < ActiveRecord::Base
    before_save{ self.user_name = user_name.downcase }
    belongs_to :contact
    belongs_to :ou
    has_many :employee_permissions
    has_many :permissions, through: :employee_permissions
    has_many :authenticity_tokens, dependent: :destroy
		has_many :ticket_expenses, dependent: :nullify
    has_many :tickets

    accepts_nested_attributes_for :employee_permissions
    validates :ou_id, presence: true
    validates :contact_id, presence: true
    validates :position , presence: true
    validates :date_hired, presence: true
    validates :user_name, presence: true, uniqueness: { case_sensitive: false }, length: {minimum: 6 }
    has_secure_password

    def name
        "#{self.contact.full_name}"
    end
end
