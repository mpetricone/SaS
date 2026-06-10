class TicketBillingMailer < ActionMailer::Base
    include Roadie::Rails::Automatic
    helper ApplicationHelper
    default from: ENV.fetch("MAIL_FROM", "noreply@example.com")
    def ticket_invoice(ticket, email)
        @ticket = ticket
        @ticket_totals = ticket.calculate_totals
        @ou_delivery = @ticket.ou.ou_addresses.where(invoice: true)[0].address;
        attachments.inline['corp_logo.png'] = Rails.root.join('app/assets/images/logos/corp_logo.png').read
        mail(to: email, subject: t('.subject', ou: @ticket.ou.name, client: @ticket.client.name, date: @ticket.created_at))
    end
end
