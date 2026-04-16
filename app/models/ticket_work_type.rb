class TicketWorkType < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :work_type
end
