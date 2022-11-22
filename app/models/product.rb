class Product < ActiveRecord::Base
  has_many :product_notes, dependent: :destroy
  has_many :distributer_products, dependent: :destroy
  has_many :distributers, through: :distributer_products
  has_many :product_tickets

  accepts_nested_attributes_for :distributer_products
  validates :item_number, uniqueness: {case_sensitive: true }
  validates :sku, uniqueness: { case_sensitive: true }
  validates :name, uniqueness: { case_sensitive: false }
end
