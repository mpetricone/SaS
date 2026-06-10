class ProductTicketsController < ApplicationController
  before_action { authorize ProductTicket }

	def new
		populate_new
	end

	def create
		populate_new new_params
		respond_to do |f|
			if @product_ticket.save
				f.html { redirect_to @ticket, notice: t(:notice_added, item: Ticket.model_name.human) }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_content }
				f.json { json_failure @product_ticket.errors }
			end

		end

	end

	def update
		populate_edit
		respond_to do |f|
			if @product_ticket.update new_params
				f.html { redirect_to @ticket, notice: t(:notice_updated, item: @product_ticket.product.name) }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_content }
				f.json { json_failure @product_ticket.errors }
			end

		end

	end

	def destroy
		populate_edit
		respond_to do |f|
			if @product_ticket.delete
				f.html { redirect_to @ticket, notice: t(:notice_removed, item: Product.model_name.human) }
				f.json { json_success }
			else
				f.html { redirect_to @ticket, alert: t(:alert_not_removed, item: Product.model_name.human) }
				f.json { json_failure @product_ticket.errors }
			end

		end

	end

	private
	def new_params
		params.require(:product_ticket).permit(:id, :product_id, :id_ticket, :date_sold, :price, :quantity)
	end

	def populate_new fill=nil
		if fill
			@product_ticket = ProductTicket.new fill
		else
			@product_ticket = ProductTicket.new
      # almost certainly at least 1 is sold.
      @product_ticket.quantity = 1;
		end

		@ticket = Ticket.find params[:ticket_id]
		@product_ticket.ticket = @ticket
	end

	def populate_edit
		@product_ticket = ProductTicket.find params[:id]
		@ticket = Ticket.find params[:ticket_id]
		@product_ticket.ticket = @ticket
	end
end
