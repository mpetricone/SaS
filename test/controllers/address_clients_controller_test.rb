# Address clients controller
require 'test_helper'

class AddressClientsControllerTest < ActionController::TestCase
	def setup
		@address_client = address_clients(:address_client_1_1)
		@client = clients(:client_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { client_id: @address_client.client.id }
		assert_response :success
	end

	def create_params
		{
			client_id: @client.id,
			address_client: {
				address_id: @address_client.address.id,
				uelivery: true,
				invoice: true,
				client_id: @client.id
			}
		}
	end

	test 'should create address_client' do
		assert_difference('AddressClient.count') do
			post :create, params: create_params
		end

		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should create address_client returning json' do
		assert_difference('AddressClient.count') do
			post :create, params: create_params, format: :json
		end
		assert_response :success
		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: {
			client_id: @address_client.client.id,
			id: @address_client
		}
		assert_response :success
	end

	def update_params
		{
			client_id: @address_client.client.id,
			id: @address_client,
			address_client: { delivery: false }
		}
	end

	test 'should update address_client' do
		patch :update, params: update_params
		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should update address_client returning json' do
		patch :update, params: update_params, format: :json
		assert_response :success
		assert_json_success
	end

	test 'should destroy address_client' do
		assert_difference('AddressClient.count', -1) do
			delete :destroy, params: { client_id: @client.id, id: @address_client }
		end

		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should destroy address_client returning json' do
		assert_difference('AddressClient.count', -1) do
			delete :destroy, params: {client_id: @client.id, id: address_clients(:address_client_2_1) },format: :json
		end
		assert_response :success
		assert_json_success
	end
end
