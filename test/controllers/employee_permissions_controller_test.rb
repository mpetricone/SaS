require 'test_helper'

class EmployeePermissionsControllerTest < ActionController::TestCase
	def setup
		@employee_permission = employee_permissions(:employee_permission_1)
		@employee = employees(:employee_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { employee_id: @employee.id }
		assert_response :success
	end

	def create_params
		{
			employee_id: @employee.id,
			employee_permission: {
				employee_id: @employee_permission.employee.id,
				permission_id: @employee_permission.permission.id
			}
		}
	end

	test 'should create employee_permission' do
		assert_difference('EmployeePermission.count') do
			post :create, params: create_params
		end

		assert_redirected_to employee_path(assigns(:employee))
	end

	test 'should create employee permission returning json' do
		assert_difference('EmployeePermission.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: { employee_id: @employee.id, id: @employee_permission }
		assert_response :success
	end

	def update_params
		{
			employee_id: @employee.id,
			id: @employee_permission.id,
			employee_permission: { employee_id: @employee.id }
		}
	end

	test 'should update employee_permission' do
		patch :update, params: update_params
		assert_redirected_to employee_path(assigns(:employee))
	end

	test 'should update employee permissions returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy employee_permission' do
		assert_difference('EmployeePermission.count', -1) do
			delete :destroy, params: {
				employee_id: @employee.id,
				id: @employee_permission
			}
		end

		assert_redirected_to employee_path(@employee)
	end

	test 'should destroy employee permission returning json' do
		assert_difference('EmployeePermission.count', -1) do
			delete :destroy, params: { employee_id: @employee, id: @employee_permission}, format: :json
		end

		assert_json_success
	end
end
