class PaymentTerm < ApplicationRecord
  has_many :quotes, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  scope :active,    -> { where(active: true) }
  scope :ordered,   -> { order(:name) }
end
