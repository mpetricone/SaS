class ContactDistributer < ActiveRecord::Base
  belongs_to :contact
  belongs_to :distributer

  validates :contact_id, presence: true
end
