require 'test_helper'

class OuAddressesControllerTest < ActionController::TestCase
	def setup
		@ou_address = ou_addresses(:ou_address_2_1)
		@ou = ous(:ou_2)
		@address = addresses(:address_2)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { ou_id: @ou_address.ou.id }
		assert_response :success
	end

	def create_params
		{
			ou_id: @ou.id,
			ou_address: {
				address_id: @ou_address.address.id,
				ou_id: @ou.id,
				delivery: true,
				invoice: true
			}
		}
	end

	test 'should create ou_address' do
		assert_difference('OuAddress.count') do
			post :create, params: create_params
		end

		assert_redirected_to ou_path(assigns(:ou))
	end

	test 'should create ou_address returning json' do
		assert_difference('OuAddress.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: { ou_id: @ou_address.ou.id, id: @ou_address }
		assert_response :success
	end

	def update_params
		{
			ou_id: @ou_address.ou.id,
			id: @ou_address,
			ou_address: { address_id: @ou_address.address.id }
		}
	end

	test 'should update ou_address' do
		patch :update, params: update_params
		assert_redirected_to ou_path(assigns(:ou))
	end

	test 'should update ou_address returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy ou_address' do
		assert_difference('OuAddress.count', -1) do
			delete :destroy, params: { ou_id: @ou.id, id: @ou_address.id }
		end

		assert_redirected_to ou_path(assigns(:ou))
	end

	test 'should destroy ou_address returning json' do
		assert_difference('OuAddress.count', -1) do
			delete :destroy, params: { ou_id: @ou.id, id: @ou_address.id }, format: :json
		end

		assert_json_success
	end
end
