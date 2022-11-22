class WorkTypesController < ApplicationController
	before_action(only: [:show, :index, :search_by_name]) { process_permission has_read_permission(:ticket_attribute) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:ticket_attribute) }
	before_action(only: [:new, :create]) {process_permission has_create_permission(:ticket_attribute) }
	before_action(only: [:destroy]) {process_permission has_delete_permission(:ticket_attribute) }

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
				f.html { redirect_to work_types_path, notice: "#{WorkType.model_name.human} #{@work_type.name} added." }
				f.json { json_success}
			else
				f.html { render :new, status: :unprocessable_entity }
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
				f.html { redirect_to work_types_path, notice: "#{WorkType.model_name.human} #{@work_type.name} altered." }
				f.json { json_success }
			else
				f.html { render :edit,status: :unprocessable_entity }
				f.json { json_failure @work_type.errors }
			end

		end

	end

	def destroy
		@work_type = WorkType.find params[:id]
		respond_to do |f|
			if @work_type.destroy
				f.html { redirect_to work_types_path, notice: "#{WorkType.model_name.human} removed." }
				f.json { json_success }
			else
				f.html { redirect_to work_types_path, notice: "Error removing #{WorkType.model_name.human}." }
				f.json { json_failure @work_type.errors }
			end

		end

	end

	private

	def new_params
		params.require(:work_type).permit(:id, :name)
	end
end
