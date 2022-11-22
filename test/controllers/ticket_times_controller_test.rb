require 'test_helper'

class TicketTimesControllerTest < ActionController::TestCase
	def setup
		@ticket_time = ticket_times(:ticket_time_1_1)
		@ticket = tickets(:ticket_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { ticket_id: @ticket_time.ticket.id }
		assert_response :success
	end

	def create_params
		{
			ticket_id: @ticket.id,
			ticket_time: {
				date: @ticket_time.date,
				time_start: @ticket_time.time_start,
				time_end: @ticket_time.time_end,
				hours: @ticket_time.hours
			}
		}
	end

	test 'should create ticket_time' do
		assert_difference('TicketTime.count') do
			post :create, params: create_params
		end

		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should create ticket_time returning json' do
		assert_difference('TicketTime.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

=begin
	test 'should get edit' do
		get :edit, params: { ticket_id: @ticket_time.ticket.id, id: @ticket_time }
		assert_response :success
	end
=end

	def update_params
		{
			ticket_id: @ticket_time.ticket.id,
			id: @ticket_time,
			ticket_time: { hours: @ticket_time.hours }
		}
	end

	test 'should update ticket_time' do
		patch :update, params: update_params
		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should update ticket_time returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy ticket_time' do
		assert_difference('TicketTime.count', -1) do
			delete :destroy, params: { ticket_id: @ticket.id, id: @ticket_time }
		end

		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should destroy ticket_time returning json' do
		assert_difference('TicketTime.count', -1) do
			delete :destroy, params: { ticket_id: @ticket.id, id: @ticket_time }, format: :json
		end

		assert_json_success
	end
end
