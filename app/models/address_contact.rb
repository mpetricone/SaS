class AddressContact < ActiveRecord::Base
  belongs_to :contact
  belongs_to :address
  accepts_nested_attributes_for :address
end
