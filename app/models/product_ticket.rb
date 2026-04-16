class ProductTicket < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :product

  def total
    (price.to_f*quantity.to_f).round(2);
  end
end
