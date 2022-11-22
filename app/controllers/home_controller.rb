class HomeController < ApplicationController
  def index
      @ous = Ou.all.where(root: nil)
      if logged_in
      @employee_tickets = current_employee.tickets.where.not(ticket_status: TicketStatus.where(name: ["CLOSED",  "SOLVED"])).order("updated_at DESC").limit(5)
      end
  end
end
