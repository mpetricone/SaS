require 'test_helper'

class ClientPhonesControllerTest < ActionController::TestCase
	def setup
		@client_phone = client_phones(:client_phone_1_1)
		@client = clients(:client_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { client_id: @client_phone.client.id }
		assert_response :success
	end

	def create_params
		{
			client_id: @client.id,
			client_phone: {
				number: @client_phone.number,
				description: @client_phone.description,
				client_id: @client.id }
		}
	end

	test 'should create client_phone' do
		assert_difference('ClientPhone.count') do
			post :create, params: create_params
		end

		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should create client phone returning json' do
		assert_difference('ClientPhone.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: {
			client_id: @client_phone.client.id,
			id: @client_phone
		}
		assert_response :success
	end

	def update_params
		{
			client_id: @client_phone.client.id,
			id: @client_phone,
			client_phone: { number: @client_phone.number }
		}
	end

	test 'should update client_phone' do
		patch :update, params: update_params
		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should update client phones returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy client_phone' do
		assert_difference('ClientPhone.count', -1) do
			delete :destroy, params: {
				client_id: @client.id,
				id: @client_phone
			}
		end

		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should destroy client phone returning json' do
		assert_difference('ClientPhone.count', -1) do
			delete :destroy, params: { client_id: @client, id: @client_phone}, format: :json
		end

		assert_json_success
	end
end
