require 'test_helper'

class ContactEmailsControllerTest < ActionController::TestCase
	def setup
		@contact_email = contact_emails(:contact_email_1_1)
		@contact = contacts(:contact_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get index' do
		get :index, params: { contact_id: @contact.id }
		assert_response :success
		assert_not_nil assigns(:contact_emails)
	end

	test 'should get new' do
		get :new, params: { contact_id: @contact_email.contact.id }
		assert_response :success
	end

	def create_params
		{
			contact_id: @contact.id,
			contact_email: {
				address: @contact_email.address,
				contact_id: @contact.id
			}
		}
	end

	test 'should create contact_email' do
		assert_difference('ContactEmail.count') do
			post :create, params: create_params
		end

		assert_redirected_to contact_path(assigns(:contact))
	end

	test 'should create contact email returning json' do
		assert_difference('ContactEmail.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should show contact_email' do
		get :show, params: {
			contact_id: @contact_email.contact.id,
			id: @contact_email
		}
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: {
			contact_id: @contact_email.contact.id,
			id: @contact_email
		}
		assert_response :success
	end

	def update_params
		{
			contact_id: @contact_email.contact.id,
			id: @contact_email,
			contact_email: { address: @contact_email.address }
		}
	end

	test 'should update contact_email' do
		patch :update, params: update_params
		assert_redirected_to contact_path(assigns(:contact))
	end

	test 'should update contact email returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy contact_email' do
		assert_difference('ContactEmail.count', -1) do
			delete :destroy, params: { contact_id: @contact, id: @contact_email }
		end

		assert_redirected_to contact_path(assigns(:contact))
	end

	test 'should destroy contact email returning json' do
		assert_difference('ContactEmail.count', -1) do
			delete :destroy, params: { contact_id: @contact, id: @contact_email }, format: :json
		end

		assert_json_success
	end
end
