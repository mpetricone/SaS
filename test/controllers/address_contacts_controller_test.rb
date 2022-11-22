require 'test_helper'

class AddressContactsControllerTest < ActionController::TestCase
	def setup
		@address_contact = address_contacts(:address_contact_1_1)
		@contact = contacts(:contact_1)
		@address = addresses(:address_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { contact_id: @address_contact.contact.id }
		assert_response :success
	end

	def create_params
		{
			contact_id: @contact.id,
			address_contact: {
				address_id: @address_contact.address.id,
				contact_id: @contact.id,
				delivery: true,
				invoice: true
			}
		}
	end

	test 'should create address_contact' do
		assert_difference('AddressContact.count') do
			post :create, params: create_params
		end

		assert_redirected_to contact_path(assigns(:contact))
	end

	test 'should create address_contact returning json' do
		assert_difference('AddressContact.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: {
			contact_id: @address_contact.contact.id,
			id: @address_contact
		}
		assert_response :success
	end

	def update_params
		{
			contact_id: @address_contact.contact.id,
			id: @address_contact,
			address_contact: {
				address_id: @address_contact.address.id
			}
		}
	end

	test 'should update address_contact' do
		patch :update, params: update_params
		assert_redirected_to contact_path(assigns(:contact))
	end

	test 'should update address contact returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy address_contact' do
		assert_difference('AddressContact.count', -1) do
			delete :destroy, params: { contact_id: @contact, id: @address_contact }
		end

		assert_redirected_to contact_path(assigns(:contact))
	end

	test 'should destroy address contact returning json' do
		assert_difference('AddressContact.count', -1) do
			delete :destroy, params: { contact_id: @contact, id: address_contacts(:address_contact_2_1) }, format: :json
		end

		assert_json_success
	end
end
