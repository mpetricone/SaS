class TicketTimesController < ApplicationController
	@@alter_notice = "#{TicketTime.model_name.human} altered."
	before_action(only: [:show, :index]) { process_permission has_read_permission(:ticket_attribute) }
	before_action(only: [ :update]) {process_permission has_write_permission(:ticket_attribute) }
	before_action(only: [:new, :create]) {process_permission has_create_permission(:ticket_attribute) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:ticket_attribute) }

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
				f.html { redirect_to @ticket, notice: @@alter_notice }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
				f.json { json_failure @ticket_time.errors }
			end

		end

	end

=begin
    def edit
		populate_edit
	end
=end

	def update
		populate_edit
		@ticket_time.update_hours
		respond_to do |f|
			if (@ticket_time.update new_params)
				f.html { redirect_to @ticket, notice: @@alter_notice }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_entity  }
				f.json { json_failure @ticket_time.errors }
			end

		end

	end

	def destroy
		populate_edit
		respond_to do |f|
			if (@ticket_time.destroy)
				f.html { redirect_to @ticket, notice: @@alter_notice }
				f.json { json_success }
			else
				f.html { redirect_to @ticket, alert: "Error altering #{TickeTime.model_name.human }" }
				f.json { json_failure @ticket_time.errors }
			end

		end

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
