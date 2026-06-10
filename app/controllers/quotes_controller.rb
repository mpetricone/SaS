class QuotesController < ApplicationController
  before_action { authorize Quote }
  before_action :set_quote, only: [:show, :edit, :update, :destroy, :send_to_client, :accept, :decline, :convert_to_ticket, :add_addendum, :mail_to_client, :mail_to_client_send, :print_view]
  before_action :ensure_editable, only: [:edit, :update, :destroy]

  def index
    @quotes = Quote.includes(:client, :ou, :parent_quote).order(created_at: :desc).page(params[:page])
  end

  def search_by_name
    @quotes = Quote.includes(:client, :ou, :parent_quote)
                   .joins(:client)
                   .where("clients.name like ?", "%#{params[:search_name]}%")
                   .order(created_at: :desc)
                   .page(params[:page])
    render :index
  end

  def show
    @quote.expire_if_past_due!
    @totals = @quote.calculate_totals
  end

  def new
    @quote = Quote.new(employee: current_employee, ou: current_employee.ou)
  end

  def create
    attrs = quote_params.merge(
      employee_id: current_employee.id,
      ou_id:       current_employee.ou&.id,
      status:      :draft
    )
    attrs[:client_id] = resolve_client_id(params[:client_search]) if attrs[:client_id].blank?
    @quote = Quote.new(attrs)
    if @quote.save
      redirect_to @quote, notice: t(:notice_added, item: Quote.model_name.human)
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    attrs = quote_params
    if params[:client_search].present?
      resolved = resolve_client_id(params[:client_search])
      attrs[:client_id] = resolved if resolved
    end
    if @quote.update(attrs)
      redirect_to @quote, notice: t(:notice_updated, item: Quote.model_name.human)
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @quote.destroy
    redirect_to quotes_path, notice: t(:notice_removed, item: Quote.model_name.human)
  end

  def send_to_client
    @quote.send_to_client!
    redirect_to @quote, notice: t(:notice_quote_sent)
  end

  def accept
    @quote.accept!
    redirect_to @quote, notice: t(:notice_quote_accepted)
  end

  def decline
    @quote.decline!
    redirect_to @quote, notice: t(:notice_quote_declined)
  end

  def convert_to_ticket
    appended_to_existing = @quote.parent_quote&.converted_ticket_id.present?
    ticket = @quote.convert_to_ticket!
    notice_key = appended_to_existing ? :notice_addendum_appended_to_ticket : :notice_quote_converted
    redirect_to ticket, notice: t(notice_key)
  rescue => e
    redirect_to @quote, alert: e.message
  end

  def add_addendum
    unless @quote.accepted? || @quote.completed?
      redirect_to @quote, alert: t(:notice_quote_locked)
      return
    end
    addendum = @quote.build_addendum(employee: current_employee)
    if addendum.save
      redirect_to edit_quote_path(addendum), notice: t(:notice_addendum_created)
    else
      redirect_to @quote, alert: addendum.errors.full_messages.to_sentence
    end
  end

  def mail_to_client
    @candidate_emails = candidate_emails_for(@quote)
  end

  def mail_to_client_send
    selected   = Array(params[:mail_to]).reject(&:blank?)
    extra      = params[:extra_email].to_s.strip
    selected  += [extra] if extra.present?
    recipients = selected.uniq

    if recipients.empty?
      @candidate_emails = candidate_emails_for(@quote)
      flash.now[:alert] = t(:alert_quote_pick_recipient)
      render :mail_to_client, status: :unprocessable_content
      return
    end

    QuoteMailer.quote_proposal(@quote, recipients).deliver_now
    @quote.send_to_client! if @quote.draft?
    redirect_to @quote, notice: t(:notice_quote_emailed, recipients: recipients.join(", "))
  end

  def print_view
    @totals = @quote.calculate_totals
    render :print_view, layout: 'application'
  end

  private

  def set_quote
    @quote = Quote.find(params[:id])
  end

  def ensure_editable
    return if @quote.editable?
    redirect_to @quote, alert: t(:notice_quote_locked)
  end

  def quote_params
    params.require(:quote).permit(
      :client_id, :contact_id, :rate_id, :title, :description,
      :taxable, :taxable_labor, :tax_rate, :expires_at,
      :payment_term_id, :payment_terms_override
    )
  end

  def resolve_client_id(name)
    return nil if name.blank?
    Client.find_by(name: name)&.id
  end

  def candidate_emails_for(quote)
    client_addresses = quote.client.client_emails.pluck(:email)
    authorized_contact_ids = quote.client.client_contacts.where(receives_quotes: true).pluck(:contact_id)
    authorized_contacts = Contact.where(id: authorized_contact_ids).includes(:contact_emails)
    contact_buckets = authorized_contacts.map { |c| [c, c.contact_emails.map(&:address)] }
    {
      client:   client_addresses.compact.uniq,
      contacts: contact_buckets
    }
  end
end
