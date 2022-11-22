class Contact < ActiveRecord::Base
    has_many :address_contacts, dependent: :destroy
    has_many :addresses, through: :address_contacts
    has_many :contact_emails, dependent: :destroy
    has_many :contact_phones, dependent: :destroy
    has_many :employees
    has_many :tickets
    belongs_to :standing
    accepts_nested_attributes_for :contact_emails, :contact_phones, :address_contacts
    validates :fname, length: { minimum: 2,  } 
    validates :lname, length: { minimum: 2,  }
    validates :standing_id, presence: true
    
    def self.search_user(fname, lname)
        where("fname LIKE ? AND lname LIKE ?","%#{fname}%", "%#{lname}%").find_each do |c|
            yield c
        end
    end

  def full_name 
      "#{fname} #{lname}"
  end
  def full_name_alphebetical
      "#{lname}, #{fname}"
  end

end
