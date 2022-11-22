require 'test_helper'

class DistributerPhonesControllerTest < ActionController::TestCase
	def setup
		@distributer_phone = distributer_phones(:distributer_phone_1_1)
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
			distributer_phone: {
				distributer: @distributer.id,
				number: @distributer_phone.number,
				description: @distributer_phone.description
			}
		}

	end

	test 'should create distributer_phone' do
		assert_difference('DistributerPhone.count') do
			post :create, params: create_params
		end

		assert_redirected_to distributer_path(assigns(:distributer))
	end

	test 'should create distributer phone returning json' do
		assert_difference('DistributerPhone.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: {
			distributer_id: @distributer.id,
			id: @distributer_phone
		}
		assert_response :success
	end

	def update_params
		{
			distributer_id: @distributer.id,
			id: @distributer_phone,
			distributer_phone: { number: @distributer_phone.number }
		}
	end

	test 'should update distributer_phone' do
		patch :update, params: update_params
		assert_redirected_to distributer_path(assigns(:distributer))
	end

	test 'should update distributer phone returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy distributer_phone' do
		assert_difference('DistributerPhone.count', -1) do
			delete :destroy, params: {
				distributer_id: @distributer.id,
				id: @distributer_phone
			}
		end

		assert_redirected_to distributer_path(assigns(:distributer))
	end

	test 'should destroy distributer phone returning json' do
		assert_difference('DistributerPhone.count', -1) do
			delete :destroy, params: { distributer_id: @distributer, id: @distributer_phone}, format: :json
		end

		assert_json_success
	end
end
