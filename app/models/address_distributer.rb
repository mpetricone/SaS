class AddressDistributer < ActiveRecord::Base
  belongs_to :address
  belongs_to :distributer
  accepts_nested_attributes_for :address
end
