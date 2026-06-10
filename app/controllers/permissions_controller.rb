class PermissionsController < ApplicationController
  before_action { authorize Permission }

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
				f.html { redirect_to permissions_path, notice: t(:notice_added, item: @permission.name) }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_content }
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
				f.html { redirect_to permissions_path, notice: t(:notice_updated, item: @permission.name) }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_content }
				f.json { json_failure @permission.errors }
			end

		end

	end

	def destroy
		@permission = Permission.find params[:id]
		respond_to do |f|
			if @permission.destroy
				f.html {
					flash.notice = t(:notice_removed, item: Permission.model_name.human)
					redirect_to permissions_path
				}
				f.json { json_success }
			else
				f.html {
					flash.alert = t(:alert_not_removed, item: Permission.model_name.human)
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
