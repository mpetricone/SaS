class QuoteProduct < ApplicationRecord
  belongs_to :quote
  belongs_to :product

  validates :product_id, presence: true
  validates :quantity,   presence: true, numericality: { greater_than: 0 }
  validates :price,      presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate  :quote_must_be_editable, on: [:create, :update]
  before_destroy :ensure_quote_editable

  def total
    (price.to_f * quantity.to_f).round(2)
  end

  private

  def quote_must_be_editable
    errors.add(:base, :quote_locked) unless quote&.editable?
  end

  def ensure_quote_editable
    return if quote&.editable?
    errors.add(:base, :quote_locked)
    throw :abort
  end
end
