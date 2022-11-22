class TicketPaymentsController < ApplicationController
	before_action(only: [:index, :show]) { process_permission has_read_permission(:ticket_payment) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:ticket_payment) }
	before_action(only: [:new, :crete]) { process_permission has_create_permission(:ticket_payment) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:ticket_payment) }

	def new
		populate_new
	end

	def create
		populate_new new_params
		respond_to do |f|
			@ticket.update payment_received: true
			if @ticket_payment.save
				f.html { redirect_to @ticket, notice: "Payment processed" }
				f.json { json_success }
			else
				f.html { redirect_to @ticket, alert: "Error processing payment" }
				f.json { json_failure @ticket_payment.errors }
			end

		end

	end

	def edit
		populate_edit
	end

	def update
		populate_edit
		respond_to do |f|
			if @ticket_payment.update new_params
				f.html { redirect_to @ticket, notice: "Payment processed" }
				f.json { json_success }
			else
				f.html { redirect_to @ticket, alert: "Error processing payment" }
				f.json { json_failure @ticket_payment.errors }
			end

		end

	end

	def destroy
		populate_edit
		respond_to do |f|
			if @ticket_payment.destroy
				f.html { redirect_to @ticket, notice: "Payment record deleted." }
				f.json { json_success }
			else
				f.html { redirect_to @ticket, alert: "Error deleting payment record." }
				f.json { json_failure }
			end

		end

	end

	private

	def new_params
		params.require(:ticket_payment).permit(:id, :ticket_id, :date_received, :payment)
	end

	def populate_new fill=nil
		if fill
			@ticket_payment = TicketPayment.new fill
		else
			@ticket_payment = TicketPayment.new
		end

		@ticket = Ticket.find params[:ticket_id]
		@ticket_payment.ticket = @ticket
		@totals = @ticket.calculate_totals
	end

	def populate_edit
		@ticket_payment = TicketPayment.find params[:id]
		@ticket = Ticket.find params[:ticket_id]
		@ticket_payment.ticket = @ticket
		@totals = @ticket.calculate_totals
	end
end
