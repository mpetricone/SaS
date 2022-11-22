require 'test_helper'

class ClientContactsControllerTest < ActionController::TestCase
	def setup
		@client_contact = client_contacts(:client_contact_1_1)
		@client = clients(:client_1)
		@contact = contacts(:contact_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { client_id: @client_contact.client.id }
		assert_response :success
	end

	def create_params
		{
			client_id: @client.id,
			client_contact: {
				contact_id: @contact.id,
				client_id: @client.id
			}
		}
	end

	test 'should create client_contact' do
		assert_difference('ClientContact.count') do
			post :create, params: create_params
		end

		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should create client contact returning json' do
		assert_difference('ClientContact.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: {
			client_id: @client_contact.client.id, id: @client_contact }
		assert_response :success
	end

	def update_params
		{
			client_id: @client_contact.client.id,
			id: @client_contact,
			client_contact: { contact_id: @contact.id }
		}
	end

	test 'should update client_contact' do
		patch :update, params: update_params
		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should destroy client_contact' do
		assert_difference('ClientContact.count', -1) do
			delete :destroy, params: {
				client_id: @client.id,
				id: @client_contact
			}
		end

		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should destroy client contact returning json' do
		assert_difference('ClientContact.count', -1) do
			delete :destroy, params: { client_id: @client, id: client_contacts(:client_contact_2_1) }, format: :json
		end

		assert_json_success
	end
end
