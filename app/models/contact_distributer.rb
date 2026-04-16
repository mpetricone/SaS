class ContactDistributer < ActiveRecord::Base
  belongs_to :contact
  belongs_to :distributer
end
