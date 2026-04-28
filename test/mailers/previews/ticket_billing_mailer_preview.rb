# Preview all emails at http://localhost:3000/rails/mailers/ticket_billing_mailer
class TicketBillingMailerPreview < ActionMailer::Preview
  def ticket_invoice
    TicketBillingMailer.ticket_invoice(Ticket.last, 'preview@example.com')
  end
end
