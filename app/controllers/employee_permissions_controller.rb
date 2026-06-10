class EmployeePermissionsController < ApplicationController
  before_action { authorize EmployeePermission }
	before_action :populate_edit, only: [ :edit, :update, :destroy]

	def new
		populate_new
	end

	def create
		populate_new new_params

		respond_to do |f|
			if @employee_permission.save
				f.html {
					redirect_to @employee,
					notice: t(:notice_added, item: EmployeePermission.model_name.human) }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_content }
				f.json { json_failure @employee_permission.errors }
			end

		end

	end

	def edit
	end

	def update
		respond_to do |f|
			if (@employee_permission.update new_params)
				f.html {
					redirect_to @employee,
					notice: t(:notice_updated, item: EmployeePermission.model_name.human) }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_content }
				f.json { json_failure @employee_permission.errors }
			end

		end

	end

	def destroy
		respond_to do |f|
			if @employee_permission.delete
				f.html {
					redirect_to @employee,
					notice: t(:notice_removed, item: EmployeePermission.model_name.human) }
				f.json { json_success }
			else
				f.html {
					redirect_to @employee,
					alert: t(:alert_not_removed, item: EmployeePermission.model_name.human) }
				f.json { json_failure }
			end

		end

	end

	private
	def new_params
		params.require(:employee_permission).permit(:id, :employee_id, :permission_id)
	end

	def populate_new fill = nil
		if fill
			@employee_permission = EmployeePermission.new fill
		else
			@employee_permission = EmployeePermission.new
		end

		@employee = Employee.find params[:employee_id]
		@employee_permission.employee = @employee
	end

	def populate_edit
		@employee_permission = EmployeePermission.find params[:id]
		@employee = Employee.find params[:employee_id]
		@employee_permission.employee = @employee
	end
end
