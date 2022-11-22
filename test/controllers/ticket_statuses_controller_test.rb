require 'test_helper'

class TicketStatusesControllerTest < ActionController::TestCase
	def setup
		@ticket_status = ticket_statuses(:ticket_status_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:ticket_statuses)
	end

	test 'should get index returning json' do
		get :index, format: :json
		assert_response :success
	end

	test 'should search by name' do
		get :search_by_name, params: { search_name: 'ticket' }
		assert_response :success
		assert_not_nil assigns(:ticket_statuses)
	end

	test 'should search by name returning json' do
		get :search_by_name, params: { search_name: 'ticket' }, format: :json
		assert_response :success
		assert_not_nil assigns(:ticket_statuses)
	end

	test 'should get new' do
		get :new
		assert_response :success
	end

	def create_params
		{ ticket_status: { name: @ticket_status.name } }

	end

	test 'should create ticket_status' do
		assert_difference('TicketStatus.count') do
			post :create, params: create_params
		end

		assert_redirected_to ticket_statuses_path
	end

	test 'should create ticket_status returning json' do
		assert_difference('TicketStatus.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should show ticket_status' do
		get :show, params: { id: @ticket_status }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @ticket_status }
		assert_response :success
	end

	def update_params
		{
			id: @ticket_status,
			ticket_status: { name: @ticket_status.name }
		}
	end

	test 'should update ticket_status' do
		patch :update, params: update_params
		assert_redirected_to ticket_statuses_path
	end

	test 'should update ticket_status returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy ticket_status' do
		assert_difference('TicketStatus.count', -1) do
			delete :destroy, params: { id: @ticket_status }
		end

		assert_redirected_to ticket_statuses_path
	end

	test 'should destroy ticket_status returning json' do
		assert_difference('TicketStatus.count', -1) do
			delete :destroy, params: { id: @ticket_status }, format: :json
		end

		assert_json_success
	end
end
