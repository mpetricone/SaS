class EmployeePermissionsController < ApplicationController
	before_action :populate_edit, only: [ :edit, :update, :destroy]
	before_action(only: [:show, :index]) { process_permission has_read_permission(:permission_attribute) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:permission_attribute) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:permission_attribute) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:permission_attribute) }

	def new
		populate_new
	end

	def create
		populate_new new_params

		respond_to do |f|
			if @employee_permission.save
				f.html {
					redirect_to @employee,
					notice: "#{EmployeePermission.model_name.human} #{@employee_permission.permission.name} granted to #{@employee.contact.full_name}." }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
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
					notice: "#{EmployeePermission.model_name.human} #{@employee_permission.permission.name} for #{@employee.contact.full_name} updated." }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_entity }
				f.json { json_failure @employee_permission.errors }
			end

		end

	end

	def destroy
		permission = @employee_permission.permission.name
		respond_to do |f|
			if @employee_permission.delete
				f.html {
					redirect_to @employee,
					notice: "#{EmployeePermission.model_name.human} #{permission} for #{@employee.contact.full_name} revoked." }
				f.json { json_success }
			else
				f.html {
					redirect_to @employee,
					alert: "Error revoking #{EmployeePermission.model_name.human} #{permission} for #{@employee.contact.full_name}" }
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
