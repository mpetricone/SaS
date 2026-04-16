class TicketStatus < ActiveRecord::Base
    has_many :tickets
    #States used for TicketStatus.name
    SOLVED='SOLVED'
    CLOSED='CLOSED'
    ACTIVE='ACTIVE'
end
