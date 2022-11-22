require 'test_helper'

class ClientNotesControllerTest < ActionController::TestCase
	def setup
		@client_note = client_notes(:client_note_1_1)
		@client = clients(:client_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { client_id: @client_note.client.id }
		assert_response :success
	end

	def create_params
		{
			client_id: @client.id,
			client_note: {
				title: @client_note.title,
				note: @client_note.note,
				client_id: @client.id
			}
		}
	end

	test 'should create client_note' do
		assert_difference('ClientNote.count') do
			post :create, params: create_params
		end

		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should create client note returning json' do
		assert_difference('ClientNote.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: { client_id: @client_note.client.id, id: @client_note }
		assert_response :success
	end

	def update_params
		{
			client_id: @client_note.client.id,
			id: @client_note,
			client_note: { note: @client_note.note }
		}
	end

	test 'should update client_note' do
		patch :update, params: update_params
		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should update client_note returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy client_note' do
		assert_difference('ClientNote.count', -1) do
			delete :destroy, params: { client_id: @client.id, id: @client_note }
		end

		assert_redirected_to clients_show2_path(assigns(:client))
	end

	test 'should destroy client note returning json' do
		assert_difference('ClientNote.count', -1) do
			delete :destroy, params: { client_id: @client, id: @client_note }, format: :json
		end

		assert_json_success
	end
end
