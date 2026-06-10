class WorkTypesController < ApplicationController
  before_action { authorize WorkType }

	def show
		@work_type = WorkType.find params[:id]
	end

	def index
		respond_to do |f|
			f.html {
				@work_types = WorkType.page(params[:page])
				render :index
			}
			f.json {
				@work_types = WorkType.all
				render json: @work_types
			}
		end

	end

	def search_by_name
		@work_types = WorkType.where('name like ?', "%#{params[:search_name]}%")

		respond_to do |f|
			f.html {
				@work_types = @work_types.page params[:page]
				render :index
			}
			f.json { render json: @work_types }
		end

	end

	def new
		@work_type = WorkType.new
	end

	def create
		@work_type = WorkType.new new_params
		respond_to do |f|
			if @work_type.save
				f.html { redirect_to work_types_path, notice: t(:notice_added, item: WorkType.model_name.human) }
				f.json { json_success}
			else
				f.html { render :new, status: :unprocessable_content }
				f.json { json_failure @work_type.errors }
			end

		end

	end

	def edit
		@work_type = WorkType.find params[:id]
	end

	def update
		@work_type = WorkType.find params[:id]
		respond_to do |f|
			if @work_type.update new_params
				f.html { redirect_to work_types_path, notice: t(:notice_updated, item: WorkType.model_name.human) }
				f.json { json_success }
			else
				f.html { render :edit,status: :unprocessable_content }
				f.json { json_failure @work_type.errors }
			end

		end

	end

	def destroy
		@work_type = WorkType.find params[:id]
		respond_to do |f|
			if @work_type.destroy
				f.html { redirect_to work_types_path, notice: t(:notice_removed, item: WorkType.model_name.human) }
				f.json { json_success }
			else
				f.html { redirect_to work_types_path, alert: t(:alert_not_removed, item: WorkType.model_name.human) }
				f.json { json_failure @work_type.errors }
			end

		end

	end

	private

	def new_params
		params.require(:work_type).permit(:id, :name)
	end
end
