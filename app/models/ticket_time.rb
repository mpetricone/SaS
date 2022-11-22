class TicketTime < ActiveRecord::Base
  belongs_to :ticket

  # sets the hours attributes correctly, don't use the form
  def update_hours
		self.hours = (self.time_end-self.time_start)/60/60
  end
end
