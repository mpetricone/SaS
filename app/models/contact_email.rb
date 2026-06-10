class ContactEmail < ActiveRecord::Base
  belongs_to :contact

  validates :address, presence: true
end
