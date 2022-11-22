require 'test_helper'

class OuPaymentTypesControllerTest < ActionController::TestCase
	setup do
		@ou_payment_type = ou_payment_types(:one)
		logon_admin
	end

	teardown do
		logout_admin
	end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:ou_payment_types)
	end

	test 'should search by name' do
		get :search_by_name, params: { search_name: 'test' }
		assert_response :success
		assert_not_nil assigns(:ou_payment_types)
	end

	test 'should get index returning json' do
		get :index, format: :json
		assert_response :success
	end

	test 'should get new' do
		get :new
		assert_response :success
	end

	def create_params
		{
			ou_payment_type: {
				date_enabled: @ou_payment_type.date_enabled,
				date_retired: @ou_payment_type.date_retired,
				info: @ou_payment_type.info,
				method: @ou_payment_type.method,
				name: @ou_payment_type.name,
				ou_id: @ou_payment_type.ou_id
			}
		}

	end

	test 'should create ou_payment_type' do
		assert_difference('OuPaymentType.count') do
			post :create, params: create_params
		end

		assert_redirected_to ou_payment_type_path(assigns(:ou_payment_type))
	end

	test 'should create ou_payment_type retunring json' do
		assert_difference('OuPaymentType.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should show ou_payment_type' do
		get :show, params: { id: @ou_payment_type }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @ou_payment_type }
		assert_response :success
	end

	def update_params
		{
			id: @ou_payment_type,
			ou_payment_type: {
				date_enabled: @ou_payment_type.date_enabled,
				date_retired: @ou_payment_type.date_retired,
				info: @ou_payment_type.info,
				method: @ou_payment_type.method,
				name: @ou_payment_type.name,
				ou_id: @ou_payment_type.ou_id
			}
		}
	end

	test 'should update ou_payment_type' do
		patch :update, params: update_params
		assert_redirected_to ou_payment_type_path(assigns(:ou_payment_type))
	end

	test 'should update ou_payment_type returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy ou_payment_type' do
		assert_difference('OuPaymentType.count', -1) do
			delete :destroy, params: { id: @ou_payment_type }
		end

		assert_redirected_to ou_payment_types_path
	end

	test 'should destroy ou_payment_type returning json' do
		assert_difference('OuPaymentType.count', -1) do
			delete :destroy, params: { id: @ou_payment_type }, format: :json
		end

		assert_json_success
	end
end
