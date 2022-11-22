require 'test_helper'

class ClientEmailsControllerTest < ActionController::TestCase
	def setup
		@client_email = client_emails(:client_email_1_1)
		@client = clients(:client_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { client_id: @client_email.client.id }
		assert_response :success
	end

	def create_params
		{
			client_id: @client.id,
			client_email: {
				email: @client_email.email,
				description: @client_email.description,
				client_id: @client.id
			}
		}
	end

	test 'should create client_email' do
		assert_difference('ClientEmail.count') do
			post :create, params: create_params
		end

		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should create client email returning json' do
		assert_difference('ClientEmail.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: {
			client_id: @client_email.client.id,
			id: @client_email
		}
		assert_response :success
	end

	def update_params
		{
			client_id: @client_email.client.id,
			id: @client_email,
			client_email: { email: @client_email.email }
		}
	end

	test 'should update client_email' do
		patch :update, params: update_params
		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should update client email returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy client_email' do
		assert_difference('ClientEmail.count', -1) do
			delete :destroy, params: {
				client_id: @client.id,
				id: @client_email
			}
		end

		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should destroy client email returning json' do
		assert_difference('ClientEmail.count', -1) do
			delete :destroy, params: { client_id: @client, id: client_emails(:client_email_2_1) }, format: :json
		end

		assert_json_success
	end
end
