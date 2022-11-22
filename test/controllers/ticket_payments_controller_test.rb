require 'test_helper'

class TicketPaymentsControllerTest < ActionController::TestCase
	def setup
		@ticket_payment = ticket_payments(:ticket_payment_1_1)
		@ticket = tickets(:ticket_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { ticket_id: @ticket_payment.ticket.id }
		assert_response :success
	end

	def create_params
		{
			ticket_id: @ticket.id,
			ticket_payment: {
				payment: @ticket_payment.payment,
				date_received: @ticket_payment.date_received
			}
		}
	end

	test 'should create ticket_payment' do
		assert_difference('TicketPayment.count') do
			post :create, params: create_params
		end

		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should create ticket_payment returning json' do
		assert_difference('TicketPayment.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: {
			ticket_id: @ticket_payment.ticket.id,
			id: @ticket_payment
		}
		assert_response :success
	end

	def create_params
		{
			ticket_id: @ticket_payment.ticket.id,
			id: @ticket_payment,
			ticket_payment: { payment: @ticket_payment.payment }
		}
	end

	test 'should update ticket_payment' do
		patch :update, params: create_params
		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should update ticket_payment returning json' do
		patch :update, params: create_params, format: :json
		assert_json_success
	end

	test 'should destroy ticket_payment' do
		assert_difference('TicketPayment.count', -1) do
			delete :destroy, params: { ticket_id: @ticket.id, id: @ticket_payment }
		end

		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should destroy ticket_payment returning json' do
		assert_difference('TicketPayment.count', -1) do
			delete :destroy, params: { ticket_id: @ticket.id, id: @ticket_payment }, format: :json
		end

		assert_json_success
	end
end
