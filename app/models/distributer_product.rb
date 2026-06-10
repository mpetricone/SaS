class DistributerProduct < ActiveRecord::Base
  belongs_to :distributer
  belongs_to :product

  validates :distributer_id, presence: true
  validates :dist_item_number, uniqueness: { case_sensitive: true }
  validates_uniqueness_of  :distributer_id, scope: :product_id, case_sensitive: true
end
