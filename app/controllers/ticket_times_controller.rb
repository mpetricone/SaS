class TicketTimesController < ApplicationController
  before_action { authorize TicketTime }

	def new
		populate_new
		@ticket_time.date = Time.now
		@ticket_time.time_start = Time.now.round
		@ticket_time.time_start.change(usec: 0)
		@ticket_time.time_start.change(sec: 0)
		@ticket_time.time_end = (Time.now + 1.hours).round
		@ticket_time.time_end.change(usec: 0)
		@ticket_time.time_end.change(sec: 0)
	end

	def create
		populate_new new_params
		@ticket_time.update_hours
		respond_to do |f|
			if @ticket_time.save
				f.html { redirect_to @ticket, notice: t(:notice_updated, item: TicketTime.model_name.human) }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_content }
				f.json { json_failure @ticket_time.errors }
			end

		end

	end

	def edit
		populate_edit
	end

	def update
		populate_edit
		@ticket_time.update_hours
		respond_to do |f|
			if (@ticket_time.update new_params)
				f.html { redirect_to @ticket, notice: t(:notice_updated, item: TicketTime.model_name.human) }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_content }
				f.json { json_failure @ticket_time.errors }
			end

		end

	end

	def destroy
		populate_edit
		respond_to do |f|
			if (@ticket_time.destroy)
				f.html { redirect_to @ticket, notice: t(:notice_updated, item: TicketTime.model_name.human) }
				f.json { json_success }
			else
				f.html { redirect_to @ticket, alert: t(:alert_not_removed, item: TicketTime.model_name.human) }
				f.json { json_failure @ticket_time.errors }
			end

		end

	end

	def start
		@ticket = Ticket.find(params[:ticket_id])
		if @ticket.is_closed
			render json: { response: 'failure', error: t(:alert_labor_timer_closed_ticket) }, status: :unprocessable_entity
			return
		end
		if @ticket.invoice_sent?
			render json: { response: 'failure', error: t(:alert_labor_timer_invoiced_ticket) }, status: :unprocessable_entity
			return
		end
		if @ticket.ticket_times.exists?(running: true, employee_id: current_employee.id)
			render json: { response: 'failure', error: t(:alert_labor_timer_already_running) }, status: :conflict
			return
		end
		@ticket_time = @ticket.ticket_times.create!(
			running: true,
			timer_started_at: Time.current,
			employee_id: current_employee.id
		)
		render json: { id: @ticket_time.id, timer_started_at: @ticket_time.timer_started_at.iso8601 }
	end

	def stop
		populate_edit
		@ticket_time.stop_timer!
		respond_to do |f|
			f.html { redirect_to @ticket, notice: t(:notice_updated, item: TicketTime.model_name.human) }
			f.json { json_success }
		end
	end

	def resume
		populate_edit
		if @ticket.is_closed
			render json: { response: 'failure', error: t(:alert_labor_timer_closed_ticket) }, status: :unprocessable_entity
			return
		end
		if @ticket.invoice_sent?
			render json: { response: 'failure', error: t(:alert_labor_timer_invoiced_ticket) }, status: :unprocessable_entity
			return
		end
		if @ticket.ticket_times.where.not(id: @ticket_time.id).exists?(running: true, employee_id: current_employee.id)
			render json: { response: 'failure', error: t(:alert_labor_timer_already_running) }, status: :conflict
			return
		end
		@ticket_time.update!(running: true, timer_started_at: Time.current, timer_stopped_at: nil)
		render json: { id: @ticket_time.id, timer_started_at: @ticket_time.timer_started_at.iso8601 }
	end

	private
	def new_params
		params.require(:ticket_time).permit(:id, :date, :time_start, :time_end, :hours, :ticket_id)
	end

	def populate_new fill = nil
		if fill
			@ticket_time = TicketTime.new new_params
		else
			@ticket_time = TicketTime.new
		end

		@ticket = Ticket.find params[:ticket_id]
		@ticket_time.ticket = @ticket
	end

	def populate_edit
		@ticket_time = TicketTime.find params[:id]
		@ticket = Ticket.find params[:ticket_id]
		@ticket_time.ticket = @ticket
	end
end
