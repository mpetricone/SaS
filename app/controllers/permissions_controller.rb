class PermissionsController < ApplicationController
	before_action(only: [:index, :show, :search_by_name]) { process_permission has_read_permission(:permission) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:permission) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:permission) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:permission) }

	def index
		respond_to do |f|
			f.html {
				@permissions = Permission.page(params[:page]).per(15);
				render :index
			}
			f.json {
				@permissions = Permission.all.order(name: :asc)
				render json: @permissions
			}
		end

	end

	def search_by_name
		@permissions = Permission.where('name like ?', params[:search_by_name])

		respond_to do |f|
			f.html {
				@permissions = @permissions.page params[:page]
				render :index
			}
			f.json { render json: @permissions }
		end

	end

	def new
		@permission = Permission.new
	end

	def show
		@permission = Permission.find params[:id]
	end

	def create
		@permission = Permission.new new_params

		respond_to do |f|
			if @permission.save
				f.html { redirect_to permissions_path, notice: "#{@permission.name} added." }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
				f.json { json_failure @permission.errors }
			end

		end

	end

	def edit
		@permission = Permission.find params[:id]
	end

	def update
		@permission = Permission.find params[:id]

		respond_to do |f|
			if @permission.update new_params
				f.html { redirect_to permissions_path, notice: "#{@permission.name} updated." }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_entity }
				f.json { json_failure @permission.errors }
			end

		end

	end

	def destroy
		@permission = Permission.find params[:id]
		name = @permission.name
		respond_to do |f|
			if @permission.destroy
				f.html {
					flash.notice = "#{Permission.model_name.human} #{name} deleted."
					redirect_to permissions_path
				}
				f.json { json_success }
			else
				f.html {
					flash.alert = "Error deleting #{Permission.model_name.human} #{name}"
					redirect_to permissions_path
				}
				f.json { json_failure @permission.errors }
			end

		end

	end

	private

	def new_params
		params.require(:permission).permit(:id, :object_name, :name, :read_record, :write_record, :create_record, :delete_record, :admin)
	end
end
