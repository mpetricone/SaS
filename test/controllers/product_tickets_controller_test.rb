require 'test_helper'

class ProductTicketsControllerTest < ActionController::TestCase
	def setup
		@product_ticket = product_tickets(:product_ticket_1_1)
		@ticket = tickets(:ticket_1)
		@product = products(:product_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { ticket_id: @product_ticket.ticket }
		assert_response :success
	end

	def create_params
		{
			ticket_id: @ticket,
			product_ticket: {
				ticket_id: @ticket,
				product_id: @product,
				date_sold: @product_ticket.date_sold,
				quantity: @product_ticket.quantity,
				price: @product_ticket.price
			}
		}
	end

	test 'should create product_ticket' do
		assert_difference('ProductTicket.count') do
			post :create, params: create_params
		end

		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should create product_ticket returning json' do
		assert_difference('ProductTicket.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

=begin
	test 'should get edit' do
		get :edit, params: {
			ticket_id: @product_ticket.ticket.id,
			id: @product_ticket
		}
		assert_response :success
	end
=end

	def update_params
		{
			ticket_id: @product_ticket.ticket.id,
			id: @product_ticket,
			product_ticket: { quantity: @product_ticket.quantity }
		}
	end

	test 'should update product_ticket' do
		patch :update, params: update_params
		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should update product_ticket returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy product_ticket' do
		assert_difference('ProductTicket.count', -1) do
			delete :destroy, params: { ticket_id: @ticket.id, id: @product_ticket }
		end

		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should destroy product_ticket returning json' do
		assert_difference('ProductTicket.count', -1) do
			delete :destroy, params: { ticket_id: @ticket.id, id: @product_ticket }, format: :json
		end

		assert_json_success
	end
end
