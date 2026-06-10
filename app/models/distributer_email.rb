class DistributerEmail < ActiveRecord::Base
  belongs_to :distributer

  validates :email, presence: true
end
