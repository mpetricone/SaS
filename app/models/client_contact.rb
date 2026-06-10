class ClientContact < ActiveRecord::Base
  belongs_to :client
  belongs_to :contact

  validates :contact_id, presence: true
end
