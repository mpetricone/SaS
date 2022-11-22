require 'test_helper'

class ExpensesControllerTest < ActionController::TestCase
	setup do
		@expense = expenses(:one)
		logon_admin
	end

	teardown do
		logout_admin
	end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:expenses)
	end

	test 'should get index returning json' do
		get :index, format: :json
		assert_response :success
	end

	test 'should search_by_name' do
		get :search_by_name, params: { search_name: 'test'}
		assert_response :success
		assert_not_nil assigns(:expenses)
	end

	test 'should get new' do
		get :new
		assert_response :success
	end

	def create_params
		{
			expense: {
				cost: @expense.cost,
				date_incurred: @expense.date_incurred,
				description: @expense.description,
				employee_id: @expense.employee_id,
				expense_type_id: @expense.expense_type_id,
				invoice_number: @expense.invoice_number,
				name: @expense.name,
				ou_id: @expense.ou_id,
				paid: @expense.paid
			}
		}
	end

	test 'should create expense' do
		assert_difference('Expense.count') do
			post :create, params: create_params
		end

		assert_redirected_to expense_path(assigns(:expense))
	end

	test 'should create expense returning json' do
		assert_difference('Expense.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should show expense' do
		get :show, params: { id: @expense }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @expense }
		assert_response :success
	end

	def update_params
		{
			id: @expense,
			expense: {
				cost: @expense.cost,
				date_incurred: @expense.date_incurred,
				description: @expense.description,
				employee_id: @expense.employee_id,
				expense_type_id: @expense.expense_type_id,
				invoice_number: @expense.invoice_number,
				name: @expense.name,
				ou_id: @expense.ou_id,
				paid: @expense.paid
			}
		}
	end

	test 'should update expense' do
		patch :update, params: update_params
		assert_redirected_to expense_path(assigns(:expense))
	end

	test 'should update expenses returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy expense' do
		assert_difference('Expense.count', -1) do
			delete :destroy, params: { id: @expense }
		end

		assert_redirected_to expenses_path
	end

	test 'should destroy expense returning json' do
		assert_difference('Expense.count', -1) do
			delete :destroy, params: { id: @expense }, format: :json
		end

		assert_json_success
	end
end
