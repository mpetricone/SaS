class OuPaymentType < ActiveRecord::Base
  belongs_to :ou
  validates :ou_id, presence: true
  validates :method, presence: true
  validates :name, presence: true
  validates :date_enabled, presence: true
end
