class TicketInfo < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :employee
end
