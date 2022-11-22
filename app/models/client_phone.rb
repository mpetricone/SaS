class ClientPhone < ActiveRecord::Base
  belongs_to :client
  validates :number, presence: true
end
