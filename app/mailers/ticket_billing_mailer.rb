class TicketBillingMailer < ActionMailer::Base
    include Roadie::Rails::Automatic
    helper ApplicationHelper
    default from: "matt@solidstate.solutions"
    def ticket_invoice(ticket, email)
        @ticket = ticket
        @ticket_totals = ticket.calculate_totals
        @ou_delivery = @ticket.ou.ou_addresses.where(invoice: true)[0].address;
        mail(to: email, subject: "#{@ticket.ou.name}, Invoice for #{@ticket.client.name} on #{@ticket.created_at}")
    end
end
