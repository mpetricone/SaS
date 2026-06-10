class QuotePolicy < ApplicationPolicy
  permission_name :quote

  def print_view?           = read?
  def mail_to_client?       = read?
  def send_to_client?       = write?
  def accept?               = write?
  def decline?              = write?
  def convert_to_ticket?    = write?
  def add_addendum?         = write?
  def mail_to_client_send?  = write?
end
