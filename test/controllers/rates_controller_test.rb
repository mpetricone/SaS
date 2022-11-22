require 'test_helper'

class RatesControllerTest < ActionController::TestCase
	def setup
		@rate = rates(:one)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:rates)
	end

	test 'should get index returning json' do
		get :index, format: :json
		assert_response :success
	end

	test 'should search by name' do
		get :search_by_name, params: { search_name: 'rate' }
		assert_response :success
		assert_not_nil assigns(:rates)
	end

	test 'should search by name returning json' do
		get :search_by_name, params: { search_name: 'rate' }, format: :json
		assert_response :success
		assert_not_nil assigns(:rates)
	end

	test 'should get new' do
		get :new
		assert_response :success
	end

	def create_params
		{
			rate: {
				rate: @rate.rate,
				date_implemented: @rate.date_implemented,
				date_retired: @rate.date_retired,
				current: @rate.current
			}
		}
	end

	test 'should create rate' do
		assert_difference('Rate.count') do
			post :create, params: create_params
		end

		assert_redirected_to rate_path(assigns(:rate))
	end

	test 'should create rate returning json' do
		assert_difference('Rate.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should show rate' do
		get :show, params: { id: @rate }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @rate }
		assert_response :success
	end

	def update_params
		{ id: @rate, rate: { rate: @rate.rate } }

	end

	test 'should update rate' do
		patch :update, params: update_params
		assert_redirected_to rate_path(assigns(:rate))
	end

	test 'should update rate return json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy rate' do
		assert_difference('Rate.count', -1) do
			delete :destroy, params: { id: @rate }
		end

		assert_redirected_to rates_path
	end

	test 'should destroy rate returning json' do
		assert_difference('Rate.count', -1) do
			delete :destroy, params: { id: @rate }, format: :json
		end

		assert_json_success
	end
end
