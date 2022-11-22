require 'test_helper'

class OuPhonesControllerTest < ActionController::TestCase
	def setup
		@ou_phone = ou_phones(:ou_phone_1_1)
		@ou = ous(:ou_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { ou_id: @ou_phone.ou.id }
		assert_response :success
	end

	def create_params
		{
			ou_id: @ou.id,
			ou_phone: {
				number: @ou_phone.number,
				description: @ou_phone.description,
				ou_id: @ou.id
			}
		}
	end

	test 'should create ou_phone' do
		assert_difference('OuPhone.count') do
			post :create, params: create_params
		end

		assert_redirected_to ou_path(assigns(:ou))
	end

	test 'should create ou_phone returning json' do
		assert_difference('OuPhone.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: { ou_id: @ou_phone.ou.id, id: @ou_phone }
		assert_response :success
	end

	def update_params
		{
			ou_id: @ou_phone.ou.id,
			id: @ou_phone,
			ou_phone: { number: @ou_phone.number }
		}
	end

	test 'should update ou_phone' do
		patch :update, params: update_params
		assert_redirected_to ou_path(assigns(:ou))
	end

	test 'should update ou_phone return json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy ou_phone' do
		assert_difference('OuPhone.count', -1) do
			delete :destroy, params: { ou_id: @ou.id, id: @ou_phone }
		end

		assert_redirected_to ou_path(assigns(:ou))
	end

	test 'should destroy ou_phone retrurning json' do
		assert_difference('OuPhone.count', -1) do
			delete :destroy, params: { ou_id: @ou.id, id: @ou_phone }, format: :json
		end

		assert_json_success
	end
end
