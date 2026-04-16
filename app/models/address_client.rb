class AddressClient < ActiveRecord::Base
  belongs_to :address
  belongs_to :client
  accepts_nested_attributes_for :address
end
