class TicketPolicy < ApplicationPolicy
  permission_name :ticket

  def index_show_list?    = read?
  def index_latest?       = read?
  def index_client_list?  = read?
  def show_tech_info?     = read?
  def print_view?         = read?
  def time?               = read?

  def close_ticket?       = write?
  def open_ticket?        = write?
  def mark_invoice_sent?  = write?
  def mail_bill?          = write?
end
