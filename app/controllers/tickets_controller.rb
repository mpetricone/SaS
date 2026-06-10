class TicketsController < ApplicationController
  before_action { authorize Ticket }
  include ActiveStorage::SetCurrent

  def index
  end

  def mail_bill
    populate_edit
    if @ticket.has_running_timers?
      redirect_to @ticket, alert: t(:alert_labor_timer_running_invoice)
      return
    end
    @ticket.stop_running_timers!
    if @ticket.invoice_date == nil
      @ticket.invoice_date = Date.today
      @ticket.save
    end

    if not params[:mail_to]
      flash[:info] = params[:mail_to]
      redirect_to @ticket, alert: t(:alert_invoice_send_failed)
      return
    end

    mail_bill_to(params[:mail_to])
  end

  def mark_invoice_sent
    populate_edit
    unless current_employee.employee_permissions.any? { |ep| ep.permission.admin }
      flash[:security] = t(:alert_permission_denied)
      redirect_to home_index_path
      return
    end
    if @ticket.has_running_timers?
      redirect_to @ticket, alert: t(:alert_labor_timer_running_mark_sent)
      return
    end
    if @ticket.invoice_sent?
      redirect_to @ticket, alert: t(:alert_invoice_already_sent)
      return
    end
    @ticket.stop_running_timers!
    @ticket.update!(payment_requested: true, invoice_date: Time.current)
    redirect_to @ticket, notice: t(:notice_invoice_marked_sent)
  end

=begin
		def mail_bill_contact
				populate_edit
				mail_bill(@ticket.contact.contact_emails[0].address)
		end

=end

  def open_ticket
    populate_edit
    respond_to do |f|
      if @ticket.is_closed
        @ticket.ticket_status = TicketStatus.find_by(name: TicketStatus::ACTIVE)
        if !@ticket.ticket_status
          flash[:alert] = t(:alert_missing_required_ticket_status_active)
          # We are fairly sure this is the problem, but guessing whether to rename or create could cause more problems, let the admins know.
          logger.error(t(:sa_ticket_status_active_missing))
          f.html { redirect_to @ticket }
          f.json { json_failure }
        elsif @ticket.save
          flash[:notice] = t(:notice_ticket_opened)
          f.html { redirect_to @ticket }
          f.json { json_success }
        else
          flash[:alert] = t(:alert_ticket_not_opened)
          f.html { redirect_to @ticket }
          f.json { json_failure @ticket.errors }
        end
      elsif flash[:notice] = t(:notice_ticket_already_opened)
        f.html { redirect_to @ticket }
        f.json { json_success }
      end
    end
  end

  def close_ticket
    populate_edit
    if @ticket.has_running_timers?
      redirect_to @ticket, alert: t(:alert_labor_timer_running_close)
      return
    end
    @ticket.stop_running_timers!
    ticket_status_solved = TicketStatus.find_by(name: TicketStatus::SOLVED)
    respond_to do |f|
      if !@ticket.is_closed
        @ticket.ticket_status = ticket_status_solved
        @ticket.date_resolved = DateTime.now
        if @ticket.save
          flash[:notice] = t(:notice_ticket_closed, label: "#{@ticket.client.name}.#{@ticket.short_description}.#{@ticket.id}")
          f.html { redirect_to tickets_path }
          f.json { json_success }
        else
          flash[:alert] = t(:alert_ticket_not_closed, ref: @ticket.id, errors: @ticket.errors.full_messages.join(', '))
          f.html { redirect_to @ticket }
          f.json { json_failure @ticket.errors }
        end
      else
        flash[:notice] = t(:notice_ticket_already_closed, label: "#{@ticket.client.name}.#{@ticket.short_description}.#{@ticket.id}")
        f.html { redirect_to @ticket }
        f.json { json_success }
      end
    end
  end

  def print_view
    populate_edit
    @ou_delivery = @ticket.ou.ou_addresses.where(invoice: true)[0].address
    @ou_invoice = @ticket.ticket_invoice_address
    @ticket_totals = @ticket.calculate_totals
  end

  def show_tech_info
    populate_edit
  end

  def index_client_list
    @clients = Client.where("name LIKE ?", "%#{params[:client_name]}%").page(params[:client_page]).per(15)
    respond_to do |format|
      format.js { render }
    end
  end

  def index_show_list
    @client = Client.find(params[:client_id])
    if request.format != :json
      @tickets = Ticket.where(client_id: params[:client_id]).page(params[:index_page])
    else
      @tickets = Ticket.where(client_id: params[:client_id])
    end

    if params[:search][:search_solved] == "false"
      @tickets = @tickets.where.not(ticket_status: TicketStatus.where(name: [TicketStatus::CLOSED, TicketStatus::SOLVED]))
    end

    if params[:search][:search_dates] == "true"
      @tickets = @tickets.where date_created: params[:search][:date_start]..params[:search][:date_end]
    end

    respond_to do |format|
      format.js { render }
      format.json { render json: @tickets }
    end
  end

  def index_latest
    @tickets = Ticket.where.not(ticket_status: TicketStatus.where(name: [TicketStatus::CLOSED, TicketStatus::SOLVED])).order("updated_at DESC").limit(params[:limit])
    respond_to do |f|
      f.json { render json: @tickets }
      f.js { }
    end
  end

  def show
    populate_edit
    @ticket_totals = @ticket.calculate_totals
    @running_timer = @ticket.ticket_times.find_by(running: true, employee_id: current_employee&.id)
    respond_to do |f|
      f.html { render :show }
      f.json {
        render json: {
                 ticket: @ticket,
                 product_tickets: @ticket.product_tickets,
                 products: @ticket.products,
                 ticket_work_types: @ticket.ticket_work_types,
                 work_types: @ticket.work_types,
                 ticket_actions: @ticket.ticket_actions,
                 ticket_action_statuses: @ticket.ticket_action_statuses,
                 ticket_times: @ticket.ticket_times,
                 ticket_payments: @ticket.ticket_payments,
                 ticket_status: @ticket.ticket_status,
                 ticket_delivery_address: @ticket.ticket_delivery_address,
                 ticket_invoice_address: @ticket.ticket_invoice_address,
                 employee: @ticket.employee,
                 rate: @ticket.rate,
                 ou: @ticket.ou,
                 client: @ticket.client,
                 totals: @ticket_totals,
               }
      }
    end
  end

  def time
    populate_edit
    respond_to do |f|
      f.json { render json: { time: @ticket.calculate_hours } }
    end
  end

  def new
    populate_new
    if @ticket.client.tax_exemption == nil || @ticket.client.tax_exemption == ""
      @ticket.taxable = true
      @ticket.taxable_labor = true
    else
      @ticket.tax_exemption = @ticket.client.tax_exemption
      @ticket.taxable = false
      @ticket.taxable_labor = false
    end

    @ticket.tax_id = current_employee.ou.tax_id

    rate = @ticket.client.client_rates.order("created_at").where(current: :true).limit(1)
    if rate.size() > 0
      @ticket.rate_id = rate[0].rate_id
    end

    if !@ticket.client.has_all_address_types?
      flash[:alert] = t(:alert_client_need_deliverable_addresses)
      redirect_to edit_client_path(@ticket.client)
    end
  end

  def create
    populate_new new_params
    @ticket.ticket_invoice_address = @ticket.client.default_invoice_address
    @ticket.ticket_delivery_address = @ticket.client.default_delivery_address
    @ticket.ticket_ou_address = @ticket.employee.ou.addresses.first
    @ticket.date_created = Date.today

    setTaxInfo
    respond_to do |f|
      if (@ticket.save)
        f.html { redirect_to @ticket, notice: t(:notice_added, item: Ticket.model_name.human) }
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_content }
        f.json { json_failure @ticket.errors }
      end
    end
  end

  def edit
    populate_edit
  end

  def update
    populate_edit
    @ticket.updated_at = DateTime.now
    setTaxInfo
    respond_to do |f|
      if (@ticket.update new_params)
        f.html { redirect_to @ticket, notice: t(:notice_updated, item: Ticket.model_name.human) }
        f.json { json_success }
      else
        f.html { render :edit, status: :unprocessable_content }
        f.json { json_failure @ticket.errors }
      end
    end
  end

  def destroy
    populate_edit
	# remove images before image is deleted
    @ticket.ticket_pictures.each { |t| t.image.purge }
    respond_to do |f|
      if (@ticket.destroy)
        f.html { redirect_to tickets_path, notice: t(:notice_removed, item: Ticket.model_name.human) }
        f.json { json_success }
      else
        f.html { redirect_to tickets_path, alert: t(:alert_not_removed, item: Ticket.model_name.human) }
        f.json { json_failure @ticket.errors }
      end
    end
  end

  private

  def new_params
    params.require(:ticket).permit(:id, :client_id, :contact_id, :employee_id, :rate_id, :ticket_status_id,
                                   :cost_parts, :date_created, :date_resolved, :short_description,
                                   :billing_hourly, :billing_fixed, :billing_fixed_value, :tax_rate,
                                   :payment_requested, :payment_payed, :payment_received, :invoice_date,
                                   :default_invoice_id, :default_delivery_id, :ou_address_id, :ou_id, :tax,
                                   :taxable, :tax_exemption, :taxable_labor, :field_location, :tax_id,
                                   ticket_infos_attributes: [:id, :ticket_id, :info, :employee_id, :date_created],
                                   shipment_trackings_attributes: [:id, :ticket_id, :date_shiped, :item_count],
                                   ticket_work_types_attributes: [:id, :ticket_id, :work_type_id],
                                   product_tickets_attributes: [:id, :ticket_id, :product_id, :date_sold, :price])
  end

  def populate_new(fill = nil)
    if fill
      @ticket = Ticket.new new_params
    else
      @ticket = Ticket.new
    end

    if params.has_key? :client_id
      @client = Client.find params[:client_id]
      @ticket.client = @client
    end
  end

  def populate_edit
    @ticket = Ticket.find params[:id]
  end

  def mail_bill_to(email)
    TicketBillingMailer.ticket_invoice(@ticket, email).deliver
    if !@ticket.update payment_requested: true
      flash[:alert] = t(:alert_payment_status_failed)
    end

    if not @ticket.ticket_delivery_address and @ticket.ticket_invoice_address
      redirect_to edit_ticket_path(@ticket), alert: t(:alert_ticket_address_required)
      return
    end

    flash[:notice] = t(:notice_invoice_sent, email: email)
    redirect_to @ticket
  end

  def setTaxInfo
    if params.has_key? :tax
      if params[:tax].has_key?(:selected_tax)
        tax = Tax.find(params[:tax][:selected_tax])
        @ticket.tax_rate = tax.rate
        @ticket.tax_id = tax.id
      end
    end

    if !@ticket.taxable && (@ticket.tax_exemption == nil || @ticket.tax_exemption == "")
      @ticket.tax_exemption = @ticket.client.tax_exemption
    end
  end
end
