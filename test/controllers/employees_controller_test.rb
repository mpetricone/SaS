require 'test_helper'

class EmployeesControllerTest < ActionController::TestCase
	def setup
		@employee = employees(:employee_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

  test 'should not access page' do
    should_not_access_data @employee, update_params
    get :search_by_name, params: { search_name: 'employee' }
    assert_redirected_to home_index_path
  end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:employees)
	end

	test 'should get index returning json' do
		get :index, format: :json
		assert_response :success
	end

	test 'should search by name' do
		get :search_by_name, params: { search_name: 'employee' }
		assert_response :success
		assert_not_nil assigns(:employees)
	end

	test 'should searh by name returning json' do
		get :search_by_name, params: {search_name: 'employee'}, format: :json
		assert_response :success
		assert_not_nil assigns(:employees)
	end

	test 'should get new' do
		get :new
		assert_response :success
	end

	def create_params
		{
			employee: {
				user_name: @employee.user_name,
				contact_id: @employee.contact.id,
				ou_id: @employee.ou.id,
				date_hired: @employee.date_hired,
				position: @employee.position,
				password:  'testest1',
				password_confirmation: 'testest1'
			}
		}
	end

	test 'should create employee' do
		@employee.user_name = "#{@employee.user_name}-1"
		assert_difference('Employee.count') do
			post :create, params: create_params
		end

		assert_redirected_to employee_path(assigns(:employee))
	end

	test 'should create employee returning json' do
		@employee.user_name = "#{@employee.user_name}-1-1"
		assert_difference('Employee.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should show employee' do
		get :show, params: { id: @employee }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @employee }
		assert_response :success
	end

	def update_params
		{
			id: @employee,
			employee: { user_name: @employee.user_name }
		}
	end

	test 'should update employee' do
		patch :update, params: update_params
		assert_redirected_to employee_path(assigns(:employee))
	end

	test 'should update employee returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

end
