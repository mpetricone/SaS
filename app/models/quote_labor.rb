class QuoteLabor < ApplicationRecord
  belongs_to :quote
  belongs_to :rate, optional: true

  enum :billing, { fixed: 0, hourly: 1 }

  validates :description, presence: true
  validates :amount,          presence: true, if: :fixed?
  validates :estimated_hours, presence: true, if: :hourly?
  validates :rate_id,         presence: true, if: :hourly?
  validate  :quote_must_be_editable, on: [:create, :update]
  before_destroy :ensure_quote_editable

  def line_total
    if fixed?
      amount.to_f.round(2)
    else
      (estimated_hours.to_f * rate&.rate.to_f).round(2)
    end
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
