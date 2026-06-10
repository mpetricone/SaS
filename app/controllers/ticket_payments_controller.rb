class TicketPaymentsController < ApplicationController
  before_action { authorize TicketPayment }

	def new
		populate_new
	end

	def create
		populate_new new_params
		respond_to do |f|
			@ticket.update payment_received: true
			if @ticket_payment.save
				f.html { redirect_to @ticket, notice: t(:notice_payment_processed) }
				f.json { json_success }
			else
				f.html { redirect_to @ticket, alert: t(:alert_payment_processing_failed) }
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
				f.html { redirect_to @ticket, notice: t(:notice_payment_processed) }
				f.json { json_success }
			else
				f.html { redirect_to @ticket, alert: t(:alert_payment_processing_failed) }
				f.json { json_failure @ticket_payment.errors }
			end

		end

	end

	def destroy
		populate_edit
		respond_to do |f|
			if @ticket_payment.destroy
				f.html { redirect_to @ticket, notice: t(:notice_payment_deleted) }
				f.json { json_success }
			else
				f.html { redirect_to @ticket, alert: t(:alert_payment_delete_failed) }
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
