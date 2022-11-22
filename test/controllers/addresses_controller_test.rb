require 'test_helper'

class AddressesControllerTest < ActionController::TestCase
	def setup
		@address = addresses(:one)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:addresses)
	end

	test 'should get index returning json' do
		get :index, format: :json
		assert_not_nil assigns(:addresses)
		assert_response :success
	end

	test 'should search by name' do
		get :search_by_name, params: { search_name: 'address' }
		assert_response :success
		assert_not_nil assigns(:addresses)
	end

	test 'should search by name returning json' do
		get :search_by_name, params: {search_name: 'address' }, format: :json
		assert_not_nil assigns(:addresses)
		assert_response :success
	end

	test 'should get new' do
		get :new
		assert_response :success
	end

	def create_params
		{
			address: {
				street1: @address.street1,
				street2: @address.street2,
				city: @address.city,
				state: @address.state,
				postal_code: @address.postal_code,
				country: @address.country,
				status: @address_status
			}
		}
	end

	test 'should create address' do
		assert_difference('Address.count') do
			post :create, params: create_params
		end

		assert_redirected_to address_path(assigns(:address))
	end

	test 'should create address returning json' do
		assert_difference('Address.count') do
			post :create, format: :json, params: create_params
		end

		assert_json_success
	end

	test 'should show address' do
		get :show, params: { id: @address }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @address }
		assert_response :success

	end

	test 'should update address' do
		patch :update, params: {
			id: @address,
			address: {
				street1: @address.street1
			}
		}
		assert_redirected_to address_path(assigns(:address))
	end

	test 'should update address returning json' do
		patch :update, format: :json, params: { id: @address, address: { street1: @address.street1 } }
		assert_response :success
		assert_json_success
	end

	test 'should destroy address' do
		assert_difference('Address.count', -1) do
			delete :destroy, params: { id: @address }
		end

		assert_redirected_to addresses_path
	end

	test 'should destroy address returning json' do
		assert_difference('Address.count', -1) do
			delete :destroy, format: :json, params: { id: addresses(:address_2) }
		end

		assert_json_success
	end
end
