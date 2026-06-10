class TicketActionStatusesController < ApplicationController
  before_action { authorize TicketActionStatus }

	def show
		@ticket_action_status = TicketActionStatus.find params[:id]
	end

	def index
		respond_to do |f|
			f.html {
				@ticket_action_statuses = TicketActionStatus.page(params[:page])
				render :index
			}
			f.json {
				@ticket_action_statuses = TicketActionStatus.all
				render json: @ticket_action_statuses
			}
		end

	end

	def search_by_name
		@ticket_action_statuses = TicketActionStatus.where('status like ?', "%#{params[:search_name]}%")

		respond_to do |f|
			f.html {
				@ticket_action_statuses = @ticket_action_statuses.page params[:page]
				render :index
			}
			f.json { render json: @ticket_action_statuses }
		end

	end

	def new
		@ticket_action_status = TicketActionStatus.new
	end

	def create
		@ticket_action_status = TicketActionStatus.new new_params
		respond_to do |f|
			if @ticket_action_status.save
				f.html { redirect_to ticket_action_statuses_path,
						 notice: t(:notice_added, item: TicketActionStatus.model_name.human) }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_content }
				f.json { json_failure @ticket_action_status.errors }
			end

		end

	end

	def edit
		@ticket_action_status = TicketActionStatus.find params[:id]
	end

	def update
		@ticket_action_status = TicketActionStatus.find params[:id]
		respond_to do |f|
			if @ticket_action_status.update new_params
				f.html { redirect_to ticket_action_statuses_path, notice: t(:notice_updated, item: TicketActionStatus.model_name.human) }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_content }
				f.json { json_failure @ticket_action_status.errors }
			end

		end

	end

	def destroy
		@ticket_action_staus = TicketActionStatus.find params[:id]
		respond_to do |f|
			if @ticket_action_staus.destroy
				f.html { redirect_to ticket_action_statuses_path, notice: t(:notice_removed, item: TicketActionStatus.model_name.human) }
				f.json { json_success }
			else
				f.html { redirect_to ticket_action_statuses_path, alert: t(:alert_not_removed, item: TicketActionStatus.model_name.human) }
				f.json { json_failure @ticket_action_status.errors }
			end

		end

	end

	private

	def new_params
		params.require(:ticket_action_status).permit(:id, :status)
	end
end
