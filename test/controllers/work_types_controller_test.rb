require 'test_helper'

class WorkTypesControllerTest < ActionController::TestCase
	def setup
		@work_type = work_types(:work_type_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:work_types)
	end

	test 'should get index returning json' do
		get :index, format: :json
		assert_response :success
	end

	test 'should search_by_name' do
		get :search_by_name, params: { search_name: 'work_type' }
		assert_response :success
		assert_not_nil assigns(:work_types)
	end

	test 'should search_by_name returning json' do
		get :search_by_name, params: { search_name: 'work_type' }
		assert_response :success
		assert_not_nil assigns(:work_types)
	end

	test 'should get new' do
		get :new
		assert_response :success
	end

	def create_params
		{ work_type: { name: @work_type.name } }

	end

	test 'should create work_type' do
		assert_difference('WorkType.count') do
			post :create, params: create_params
		end

		assert_redirected_to work_types_path
	end

	test 'should create work_type returning json' do
		assert_difference('WorkType.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should show work_type' do
		get :show, params: { id: @work_type }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @work_type }
		assert_response :success
	end

	def update_params
		{
			id: @work_type,
			work_type: { name: @work_type.name }
		}
	end

	test 'should update work_type' do
		patch :update, params: update_params
		assert_redirected_to work_types_path
	end

	test 'should update work_type returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy work_type' do
		assert_difference('WorkType.count', -1) do
			delete :destroy, params: { id: @work_type }
		end

		assert_redirected_to work_types_path
	end

	test 'should destroy work_type returning json' do
		assert_difference('WorkType.count', -1) do
			delete :destroy, params: { id: @work_type }, format: :json
		end

		assert_json_success
	end
end
