class TicketActionStatus < ActiveRecord::Base
    has_many :ticket_actions
end
