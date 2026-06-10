class LaborTimersController < ApplicationController
  before_action { authorize :labor_timer }

  def index
    @is_admin = admin?

    @running_timers = if @is_admin
      TicketTime.includes(ticket: :client, employee: :contact).where(running: true).to_a
    else
      current_employee.ticket_times
        .includes(ticket: :client)
        .where(running: true)
        .to_a
    end

    stopped_base = @is_admin ?
      TicketTime.includes(ticket: :client, employee: :contact) :
      current_employee.ticket_times.includes(ticket: :client)

    @stopped_timers = stopped_base
      .where(running: false)
      .where.not(timer_started_at: nil)
      .joins(:ticket)
      .where.not(tickets: { ticket_status_id: closed_status_ids })
      .where(tickets: { payment_requested: [false, nil] })
      .order(timer_stopped_at: :desc)
      .to_a

    if params[:client_name].present?
      @search_client = params[:client_name]
      @search_tickets = Ticket
        .includes(:client)
        .joins(:client)
        .where("clients.name LIKE ?", "%#{params[:client_name]}%")
        .where(billing_hourly: true)
        .where.not(ticket_status_id: closed_status_ids)
        .where(payment_requested: [false, nil])
        .order("clients.name")
    end
  end

  def stop_all
    unless admin?
      flash[:security] = t(:alert_permission_denied)
      redirect_to home_index_path
      return
    end
    TicketTime.where(running: true).each(&:stop_timer!)
    redirect_to labor_timers_path, notice: t(:notice_all_timers_stopped)
  end

  private

  def admin?
    current_employee.employee_permissions.any? { |ep| ep.permission.admin }
  end

  def closed_status_ids
    TicketStatus.where(name: [TicketStatus::CLOSED, TicketStatus::SOLVED]).ids
  end
end
