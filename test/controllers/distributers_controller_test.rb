require 'test_helper'

class DistributersControllerTest < ActionController::TestCase
	def setup
		@distributer = distributers(:one)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:distributers)
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
			distributer: {
				name: @distributer.name,
				min_purchase: @distributer.min_purchase,
				min_purchase_freq: @distributer.min_purchase_freq,
				date_enabled: @distributer.date_enabled,
				date_disbaled: @distributer.date_disabled
			}
		}
	end

	test 'should create distributer' do
		assert_difference('Distributer.count') do
			post :create, params: create_params
		end

		assert_redirected_to distributers_path
	end

	test 'should create distributer returning json' do
		assert_difference('Distributer.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should search by name' do
		get :search_by_name, params: { search_name: 'distributer' }
		assert_response :success
		assert_not_nil assigns(:distributers)
	end

	test 'should search by name returning json' do
		get :search_by_name, params: {search_name: 'distributers' }, format: :json
		assert_response :success
		assert_not_nil assigns(:distributers)
	end

	test 'should show distributer' do
		get :show, params: { id: @distributer }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @distributer }
		assert_response :success
	end

	def update_params
		{
			id: @distributer,
			distributer: { name: @distributer.name }
		}
	end

	test 'should update distributer' do
		patch :update, params: update_params
		assert_redirected_to distributer_path(assigns(:distributer))
	end

	test 'should udpate distributer returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy distributer' do
		assert_difference('Distributer.count', -1) do
			delete :destroy, params: { id: @distributer }
		end

		assert_redirected_to distributers_path
	end

	test 'should destroy distributer returning json' do
		assert_difference('Distributer.count', -1) do
			delete :destroy, params: { id: @distributer }, format: :json
		end

	end
end
