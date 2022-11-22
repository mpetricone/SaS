require 'test_helper'

class ExpenseTypesControllerTest < ActionController::TestCase
	setup do
		@expense_type = expense_types(:one)
		logon_admin
	end

	teardown do
		logout_admin
	end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:expense_types)
	end

	test 'should get index returning json' do
		get :index, format: :json
		assert_response :success
		assert_not_nil assigns(:expense_types)
	end

	test 'should search by name' do
		get :search_by_name, params: { search_name: 'expense_type' }
		assert_response :success
		assert_not_nil assigns(:expense_types)
	end

	test 'should search by name returning json' do
		get :search_by_name, params: { search_name: 'expense_type' }, format: :json
		assert_response :success
		assert_not_nil assigns(:expense_types)
	end

	test 'should get new' do
		get :new
		assert_response :success
	end

	def create_params
		{
			expense_type: {
				description: @expense_type.description,
				name: @expense_type.name
			}
		}
	end

	test 'should create expense_type' do
		assert_difference('ExpenseType.count') do
			post :create, params: create_params
		end

		assert_redirected_to expense_types_path
	end

	test 'should create expense_type returning json' do
		assert_difference('ExpenseType.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should show expense_type' do
		get :show, params: { id: @expense_type }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @expense_type }
		assert_response :success
	end

	def update_params
		{
			id: @expense_type,
			expense_type: {
				description: @expense_type.description,
				name: @expense_type.name
			}
		}
	end

	test 'should update expense_type' do
		patch :update, params: update_params
		assert_redirected_to expense_type_path(assigns(:expense_type))
	end

	test 'should update expense type returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should not destroy expense_type' do
		assert_difference('ExpenseType.count', 0) do
			delete :destroy, params: { id: @expense_type }
		end

		assert_redirected_to expense_types_path
	end

	test 'should not destroy expense_type returning json' do
		assert_difference('ExpenseType.count', 0) do
			delete :destroy, params: { id: @expense_type }, format: :json
		end

		assert_json_success
	end
end
