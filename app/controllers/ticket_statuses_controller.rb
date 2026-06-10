class TicketStatusesController < ApplicationController
  before_action { authorize TicketStatus }

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
				f.html { redirect_to ticket_statuses_path, notice: t(:notice_added, item: TicketStatus.model_name.human) }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_content }
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
				f.html { redirect_to ticket_statuses_path, notice: t(:notice_updated, item: TicketStatus.model_name.human) }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_content }
				f.josn { json_failure @ticket_status.errors }
			end

		end

	end

	def destroy
		@ticket_status = TicketStatus.find params[:id]
		respond_to do |f|
			if @ticket_status.destroy
				f.html { redirect_to ticket_statuses_path, notice: t(:notice_removed, item: TicketStatus.model_name.human)}
				f.json { json_success }
			else
				f.html { redirect_to ticket_statuses_path, alert: t(:alert_not_removed, item: TicketStatus.model_name.human)}
				f.json { json_failure }
			end

		end

	end

	private

	def new_params
		params.require(:ticket_status).permit(:id, :name)
	end
end
