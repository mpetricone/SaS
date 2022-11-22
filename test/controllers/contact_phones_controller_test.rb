require 'test_helper'

class ContactPhonesControllerTest < ActionController::TestCase
	def setup
		@contact_phone = contact_phones(:contact_phone_1_1)
		@contact = contacts(:contact_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { contact_id: @contact_phone.contact.id }
		assert_response :success
	end

	def create_params
		{
			contact_id: @contact.id,
			contact_phone: {
				number: @contact_phone.number,
				phone_type: @contact_phone.phone_type,
				contact_id: @contact.id
			}
		}
	end

	test 'should create contact_phone' do
		assert_difference('ContactPhone.count') do
			post :create, params: create_params
		end

		assert_redirected_to contact_path(assigns(:contact))
	end

	test 'should create contact phone returning json' do
		assert_difference('ContactPhone.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: {
			contact_id: @contact_phone.contact.id,
			id: @contact_phone
		}
		assert_response :success
	end

	def update_params
		{
			contact_id: @contact_phone.contact.id,
			id: @contact_phone,
			contact_phone: { number: @contact_phone.number }
		}
	end

	test 'should update contact_phone' do
		patch :update, params: update_params
		assert_redirected_to contact_path(assigns(:contact))
	end

	test 'should update contact phone returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy contact_phone' do
		assert_difference('ContactPhone.count', -1) do
			delete :destroy, params: { contact_id: @contact.id, id: @contact_phone }
		end

		assert_redirected_to contact_path(assigns(:contact))
	end

	test 'should destroy contact phone returning json' do
		assert_difference('ContactPhone.count', -1) do
			delete :destroy, params: { contact_id: @contact, id: @contact_phone }, format: :json
		end

		assert_json_success
	end
end
