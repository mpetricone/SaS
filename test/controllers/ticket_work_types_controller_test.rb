require 'test_helper'

class TicketWorkTypesControllerTest < ActionController::TestCase
	def setup
		@ticket_work_type = ticket_work_types(:ticket_work_type_1_1)
		@ticket = tickets(:ticket_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { ticket_id: @ticket_work_type.ticket.id }
		assert_response :success
	end

	def create_params
		{
			ticket_id: @ticket.id,
			ticket_work_type: {
				ticket_id: @ticket.id,
				work_type_id: @ticket_work_type.work_type.id
			}
		}
	end

	test 'should create ticket_work_type' do
		assert_difference('TicketWorkType.count') do
			post :create, params: create_params
		end

		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should create ticket_work_type returning json' do
		assert_difference('TicketWorkType.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: {
			ticket_id: @ticket_work_type.ticket.id,
			id: @ticket_work_type
		}
		assert_response :success
	end

	def update_params
		{
			ticket_id: @ticket_work_type.ticket.id,
			id: @ticket_work_type,
			ticket_work_type: { work_type_id: @ticket_work_type.work_type.id }
		}
	end

	test 'should update ticket_work_type' do
		patch :update, params: update_params
		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should update ticket_work_type returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy ticket_work_type' do
		assert_difference('TicketWorkType.count', -1) do
			delete :destroy, params: { ticket_id: @ticket.id, id: @ticket_work_type }
		end

		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should destroy ticket_work_type returning json' do
		assert_difference('TicketWorkType.count', -1) do
			delete :destroy, params: { ticket_id: @ticket.id, id: @ticket_work_type }, format: :json
		end

		assert_json_success
	end
end
