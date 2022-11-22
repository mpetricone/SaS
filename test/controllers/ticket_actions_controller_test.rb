require 'test_helper'

class TicketActionsControllerTest < ActionController::TestCase
	def setup
		@ticket_action = ticket_actions(:ticket_action_1_1)
		@ticket = tickets(:ticket_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { ticket_id: @ticket_action.ticket.id }
		assert_response :success
	end

	def create_params
		{
			ticket_id: @ticket.id,
			ticket_action: {
				ticket_id: @ticket_action.ticket.id,
				action_status_id: @ticket_action.ticket_action_status.id,
				employee_id: @ticket_action.employee.id,
				date_taken: @ticket_action.date_taken,
				action: @ticket_action.action
			}
		}
	end

	test 'should create ticket_action' do
		assert_difference('TicketAction.count') do
			post :create, params: create_params
		end

		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should create ticket_action returning json' do
		assert_difference('TicketAction.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: {
			ticket_id: @ticket_action.ticket.id,
			id: @ticket_action
		}
		assert_response :success
	end

	def update_params
		{
			ticket_id: @ticket_action.ticket.id,
			id: @ticket_action,
			ticket_action: { action: @ticket_action.action }
		}
	end

	test 'should update ticket_action' do
		patch :update, params: update_params
		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should update ticket_action returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy ticket_action' do
		assert_difference('TicketAction.count', -1) do
			delete :destroy, params: { ticket_id: @ticket.id, id: @ticket_action }
		end

		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should destroy ticket_action returning json' do
		assert_difference('TicketAction.count', -1) do
			delete :destroy, params: { ticket_id: @ticket.id, id: @ticket_action }, format: :json
		end

		assert_json_success
	end
end
