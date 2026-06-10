class DistributerPhone < ActiveRecord::Base
  belongs_to :distributer

  validates :number, presence: true
end
