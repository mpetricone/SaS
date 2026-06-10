class TicketTimePolicy < ApplicationPolicy
  permission_name :ticket_attribute

  def start?  = create?
  def stop?   = write?
  def resume? = write?
end
