class ProductTicket < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :product

  validates :product_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def total
    (price.to_f*quantity.to_f).round(2);
  end
end
