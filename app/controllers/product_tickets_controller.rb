class ProductTicketsController < ApplicationController
	before_action(only: [:show, :index]) { process_permission has_read_permission(:ticket_attribute) }
	before_action(only: [ :update]) { process_permission has_write_permission(:ticket_attribute) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:ticket_attribute) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:ticket_attribute) }

	def new
		populate_new
	end

	def create
		populate_new new_params
		respond_to do |f|
			if @product_ticket.save
				f.html { redirect_to @ticket, notice: "#{@product_ticket.product.name} added to #{Ticket.model_name.human}" }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
				f.json { json_failure @product_ticket.errors }
			end

		end

	end

	def update
		populate_edit
		respond_to do |f|
			if @product_ticket.update new_params
				f.html { redirect_to @ticket, notice: "#{@product_ticket.product.name} updated." }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_entity }
				f.json { json_failure @product_ticket.errors }
			end

		end

	end

	def destroy
		populate_edit
		respond_to do |f|
			if @product_ticket.delete
				f.html { redirect_to @ticket, notice: "#{Product.model_name.human} removed from #{Ticket.model_name.human}" }
				f.json { json_success }
			else
				f.html { redirect_to @ticket, alert: "Error removing #{Product.model_name.human} from #{Ticket.model_name.human}" }
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
