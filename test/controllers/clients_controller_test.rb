require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
	def setup
		@client = clients(:client_1)
		@address_client = @client.address_clients[0]
		@client_phone = @client.client_phones[0]
		@client_email = @client.client_emails[0]
		@client_rate = @client.client_rates[0]
		@address_client = @client.address_clients[0]
		@client_contact = @client.client_contacts[0]
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:clients)
	end

	test 'should get index returning json' do
		get :index, format: :json
		assert_response :success
		assert_not_nil assigns(:clients)
	end

	test 'should search_by_name' do
		get :search_by_name, params: { search_name: 'test' }
		assert_response :success
		assert_not_nil assigns(:clients)
	end

	test 'should get new' do
		get :new
		assert_response :success
	end

	test 'should be valid associations' do
		assert_not @client.address_clients.empty?
		assert_not @client.client_phones.empty?
		@client.address_clients.each do |ac|
			assert ac.client_id = @client.id
		end

		@client.client_phones.each do |cp|
			assert cp.client_id = @client.id
		end

	end

	def create_params
		{
			client: {
				name: "#{@client.name}_1",
				standing_id: @client.standing.id,
				refuse: @client.refuse,
				address_clients_attributes: {
					'0' => {
						delivery: false,
						invoice: false,
            client_id: @client.id,
						address_attributes: {
							street1: 'tests',
							city: 'test',
							postal_code: '12345',
							state:  'test',
							country: 'test'
						}
					}
				},
				client_contacts_attributes: {
					'0' => {
            client_id: @client.id,
            contact_id: @client_contact.contact_id
					}
				},
				client_emails_attributes: {
					'0' => {
						email: 'test',
						description: 'test',
            client_id: @client.id
					}
				},
				client_phones_attributes: {
					'0' => {
						number: '1245642',
						description: 'test',
            client_id: @client.id
					}
				},
				client_rates_attributes: {
					'0' => {
            rate_id: @client_rate.rate_id,
            client_id: @client.id,
					}
				},
				default_delivery_id: @client.default_delivery_address,
				default_invoice_id: @client.default_invoice_address
			}
		}
	end

	test 'should create client' do
		assert_difference('Client.count') do
			post :create, params: create_params
		end

		assert_redirected_to clients_path
	end

	test 'should create client returning json' do
		assert_difference('Client.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should show client' do
		get :show, params: { id: @client }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @client }
		assert_response :success
	end

	def update_params
		{ id: @client, client: { refuse: true } }
	end

	test 'should update client' do
		patch :update, params: update_params
		assert_redirected_to client_path(assigns(:client))
	end

	test 'should update client returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy client' do
		assert_difference('Client.count', -1) do
			delete :destroy, params: { id: @client }
		end

		assert_redirected_to clients_path
	end

	test 'should destroy client returning json' do
		assert_difference('Client.count', -1) do
			delete :destroy, params: { id: @client }, format: :json
		end

		assert_json_success
	end
end
