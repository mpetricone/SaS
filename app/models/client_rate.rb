class ClientRate < ActiveRecord::Base
  belongs_to :rate
  belongs_to :client

  validates :rate_id, presence: true
end
