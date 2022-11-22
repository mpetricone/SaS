class TicketStatusesController < ApplicationController
	before_action(only: [:show, :index, :search_by_name]) { process_permission has_read_permission(:ticket_attribute) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:ticket_attribute) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:ticket_attribute) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:ticket_attribute) }

	def show
		@ticket_status = TicketStatus.find params[:id]
	end

	def index
		respond_to do |f|
			f.html {
				@ticket_statuses = TicketStatus.page(params[:page])
				render :index
			}
			f.json {
				@ticket_statuses = TicketStatus.all
				render json: @ticket_statuses
			}
		end

	end

	def search_by_name
		@ticket_statuses = TicketStatus.where('name like ?', "%#{params[:search_name]}%")

		respond_to do |f|
			f.html {
				@ticket_statuses = @ticket_statuses.page params[:page]
				render :index
			}
			f.json { render json: @ticket_statuses }
		end

	end

	def new
		@ticket_status = TicketStatus.new
	end

	def create
		@ticket_status = TicketStatus.new new_params
		respond_to do |f|
			if (@ticket_status.save)
				f.html { redirect_to ticket_statuses_path, notice: "#{TicketStatus.model_name.human} #{@ticket_status.name} created." }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
				f.json { json_failure @ticket_status.errors }
			end

		end

	end

	def edit
		@ticket_status = TicketStatus.find params[:id]
	end

	def update
		@ticket_status = TicketStatus.find params[:id]
		respond_to do |f|
			if @ticket_status.update(new_params)
				f.html { redirect_to ticket_statuses_path, notice: "#{TicketStatus.model_name.human} #{@ticket_status.name} updated." }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_entity }
				f.josn { json_failure @ticket_status.errors }
			end

		end

	end

	def destroy
		@ticket_status = TicketStatus.find params[:id]
		respond_to do |f|
			if @ticket_status.destroy
				f.html { redirect_to ticket_statuses_path, notice: "#{TicketStatus.model_name.human} removed."}
				f.json { json_success }
			else
				f.html { redirect_to ticket_statuses_path, alert: "Error removing #{TicketStatus.model_name.human}"}
				f.json { json_failure }
			end

		end

	end

	private

	def new_params
		params.require(:ticket_status).permit(:id, :name)
	end
end
