require 'test_helper'

class ClientRatesControllerTest < ActionController::TestCase
	def setup
		@client_rate = client_rates(:client_rate_1)
		@client = clients(:client_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	#     test "should get index" do
	#         get :index, client_id: @client.id
	#         assert_response :success
	#         assert_not_nil assigns(:client_rates)
	#     end

	test 'should get new' do
		get :new, params: { client_id: @client_rate.client.id }
		assert_response :success
	end

	def create_params
		{
			client_id: @client.id,
			client_rate: {
        rate_id: @client_rate.rate.id,
				date_implemented: @client_rate.date_implemented,
				date_retired: @client_rate.date_retired,
				client_id: @client.id
			}
		}
	end

	test 'should create client_rate' do
		assert_difference('ClientRate.count') do
			post :create, params: create_params
		end

		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should create client rate returning json' do
		assert_difference('ClientRate.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: { client_id: @client_rate.client.id, id: @client_rate }
		assert_response :success
	end

	def update_params
		{
			client_id: @client_rate.client.id,
			id: @client_rate,
			client_rate: { rate: @client_rate.rate }
		}
	end

	test 'should update client_rate' do
		patch :update, params: update_params
		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should update client rate returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy client_rate' do
		assert_difference('ClientRate.count', -1) do
			delete :destroy, params: { client_id: @client.id, id: @client_rate }
		end

		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should destroy client rate returning json' do
		assert_difference('ClientRate.count', -1) do
			delete :destroy, params: {client_id: @client, id: @client_rate }, format: :json
		end

		assert_json_success
	end
end
