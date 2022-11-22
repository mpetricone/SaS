class TicketAction < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :ticket_action_status, foreign_key: 'action_status_id'
  belongs_to :employee
end
