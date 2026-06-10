class QuoteMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  helper ApplicationHelper
  default from: ENV.fetch("MAIL_FROM", "noreply@example.com")

  # recipients: String or Array<String> — assembled in QuotesController#mail_to_client_send
  # from client.client_emails and authorized client_contacts' contact_emails.
  def quote_proposal(quote, recipients)
    @quote = quote
    @quote_totals = quote.calculate_totals
    attachments.inline['corp_logo.png'] = Rails.root.join('app/assets/images/logos/corp_logo.png').read
    mail(to: Array(recipients), subject: t('.subject', code: quote.code, label: quote.title || quote.client.name))
  end
end
