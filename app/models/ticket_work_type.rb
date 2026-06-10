class TicketWorkType < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :work_type

  validates :work_type_id, presence: true
end
