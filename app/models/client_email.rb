class ClientEmail < ActiveRecord::Base
  belongs_to :client
  validates :email, presence: true
end
