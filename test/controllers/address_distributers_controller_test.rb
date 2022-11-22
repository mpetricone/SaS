require 'test_helper'

class AddressDistributersControllerTest < ActionController::TestCase
	def setup
		@address_distributer = address_distributers(:address_distributer_1_1)
		@distributer = distributers(:distributer_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { distributer_id: @distributer.id }
		assert_response :success
	end

	def create_params
		{
			distributer_id: @distributer.id,
			address_distributer: {
				distributer_id: @distributer.id,
				address_id: @address_distributer.address.id,
				invoice: true,
				delivery: false
			}
		}
	end

	test 'should create address_distributer' do
		assert_difference('AddressDistributer.count') do
			post :create, params: create_params
		end

		assert_redirected_to distributer_path(assigns(:distributer))
	end

	test 'should create address distributer returning json' do
		assert_difference('AddressDistributer.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: {
			distributer_id: @distributer.id,
			id: @address_distributer
		}
		assert_response :success
	end

	def update_params
		{
			distributer_id: @distributer.id,
			id: @address_distributer,
			address_distributer: {
				invoice: @address_distributer.invoice
			}
		}
	end

	test 'should update address_distributer' do
		patch :update, params: update_params

		assert_redirected_to distributer_path(assigns(:distributer))
	end

	test 'should update addresss distributer returning json' do
		patch :update, params: update_params, format: :json

		assert_json_success
	end

	test 'should destroy address_distributer' do
		assert_difference('AddressDistributer.count', -1) do
			delete :destroy, params: {
				distributer_id: @distributer.id,
				id: @address_distributer
			}
		end

		assert_redirected_to distributer_path(assigns(:distributer))
	end

	test 'should destroy address distributer returning json' do
		assert_difference('AddressDistributer.count', -1) do
			delete :destroy, params: { distributer_id: @distributer, id: address_distributers(:address_distributer_2_1) }, format: :json

			assert_json_success
		end

	end
end
