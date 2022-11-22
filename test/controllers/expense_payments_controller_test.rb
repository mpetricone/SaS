require 'test_helper'

class ExpensePaymentsControllerTest < ActionController::TestCase
	setup do
		@expense_payment = expense_payments(:one)
		@expense = expenses(:one)
		logon_admin
	end

	teardown do
		logout_admin
	end

	test 'should get new' do
		get :new, params: { expense_id: @expense.id }
		assert_response :success
	end

	def create_params
		{
			expense_id: @expense.id,
			expense_payment: {
				amount: @expense_payment.amount,
				expense_id: @expense_payment.expense_id,
				identifier: @expense_payment.identifier,
				ou_payment_type_id: @expense_payment.ou_payment_type_id
			}
		}
	end

	test 'should create expense_payment' do
		assert_difference('ExpensePayment.count') do
			post :create, params: create_params
		end

		assert_redirected_to expense_path(assigns(:expense))
	end

	test 'should create expense payment returning json' do
		assert_difference('ExpensePayment.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: { expense_id: @expense.id, id: @expense_payment }
		assert_response :success
	end

	def update_params
		{
			expense_id: @expense.id,
			id: @expense_payment,
			expense_payment: {
				amount: @expense_payment.amount,
				expense_id: @expense_payment.expense_id,
				identifier: @expense_payment.identifier,
				ou_payment_type_id: @expense_payment.ou_payment_type_id
			}
		}
	end

	test 'should update expense_payment' do
		patch :update, params: update_params
		assert_redirected_to expense_path(assigns(:expense))
	end

	test 'should update expense payement returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy expense_payment' do
		assert_difference('ExpensePayment.count', -1) do
			delete :destroy, params: { expense_id: @expense.id, id: @expense_payment }
		end

		assert_redirected_to expense_path(assigns(:expense))
	end

	test 'should destroy expense_payment returing json' do
		assert_difference('ExpensePayment.count', -1) do
			delete :destroy, params: { expense_id: @expense.id, id: @expense_payment }, format: :json
		end

		assert_json_success
	end
end
