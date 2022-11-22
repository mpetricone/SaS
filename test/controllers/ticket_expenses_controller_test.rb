require 'test_helper'

class TicketExpensesControllerTest < ActionController::TestCase
	def setup
		@ticket = tickets(:ticket_1)
		@employee = employees(:employee_1)
		@expense_type = expense_types(:expense_type_1)
		@te = ticket_expenses(:ticket_expense_1_1)
		@te.ticket = @ticket
		@te.employee = @employee
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { ticket_id: @ticket }
		assert_response :success
	end

	test 'should create new' do
		assert_difference('TicketExpense.count') do
			post :create, params: {
				ticket_id: @ticket,
				ticket_expense: {employee_id: @employee, cost: @te.cost, expense_type_id: @expense_type }
			}
		end

		assert_redirected_to ticket_path(assigns(:ticket))

	end

	test 'should create new reurning json' do
		assert_difference('TicketExpense.count') do
			post :create, params: {
				ticket_id: @ticket,
				ticket_expense: { employee_id: @employee, expense_type_id: @expense_type,  cost: @te.cost }
			}, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: { id: @te, ticket_id: @ticket }
		assert_response :success
	end

	test 'should update ticket expense' do
		patch :update, params: {
			ticket_id: @ticket,
			id: @te,
			ticket_expense: { expense_type_id: @expense_type, cost: @te.cost }
		}
		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should update ticket expense returning json' do
		patch :update, params: {
			ticket_id: @ticket,
			id: @te,
			ticket_expense: { expense_type_id: @expense_type, cost: @te.cost }
		}, format: :json
		assert_json_success
	end

	test 'should destroy ticket expense' do
		assert_difference('TicketExpense.count', -1) do
			delete :destroy, params: { id: @te, ticket_id: @ticket }
		end

		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should destroy ticket returning json' do
		assert_difference('TicketExpense.count', -1) do
			delete :destroy, params: { id: @te, ticket_id: @ticket }, format: :json
		end

		assert_json_success
	end
end
