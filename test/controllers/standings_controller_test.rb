require 'test_helper'

class StandingsControllerTest < ActionController::TestCase
	def setup
		@standing = standings(:one)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:standings)
	end

	test 'should get index returning json' do
		get :index, format: :json
		assert_response :success
	end

	test 'should search by name' do
		get :search_by_name, params: { search_name: 'standing' }
		assert_response :success
		assert_not_nil assigns(:standings)
	end

	test 'should search by name returning json' do
		get :search_by_name, params: { search_name: 'standing' }, format: :json
		assert_response :success
		assert_not_nil assigns(:standings)
	end

	test 'should get new' do
		get :new
		assert_response :success
	end

	def create_params
		{ standing: { name: @standing.name } }

	end

	test 'should create standing' do
		assert_difference('Standing.count') do
			post :create, params: create_params
		end

		assert_redirected_to standings_path
	end

	test 'should create standing returning json' do
		assert_difference('Standing.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should show standing' do
		get :show, params: { id: @standing }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @standing }
		assert_response :success
	end

	def update_params
		{ id: @standing, standing: { name: @standing.name } }

	end

	test 'should update standing' do
		patch :update, params: update_params
		assert_redirected_to standings_path
	end

	test 'should update standing returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy standing' do
		assert_difference('Standing.count', -1) do
			delete :destroy, params: { id: @standing }
		end

		assert_redirected_to standings_path
	end

	test 'should destroy standing retuning json' do
		assert_difference('Standing.count', -1) do
			delete :destroy, params: { id: @standing }, format: :json
		end

		assert_json_success
	end
end
