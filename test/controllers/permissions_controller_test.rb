require 'test_helper'

class PermissionsControllerTest < ActionController::TestCase
	def setup
		@permission = permissions(:permission_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:permissions)
	end

	test 'should get index returning json' do
		get :index, format: :json
		assert_response :success
	end

	test 'should search by name' do
		get :search_by_name, params: { search_name: 'permission' }
		assert_response :success
		assert_not_nil assigns(:permissions)
	end

	test 'should search by name returning json' do
		get :search_by_name, params: { search_name: 'permission' }, format: :json
		assert_response :success
		assert_not_nil assigns(:permissions)
	end

	test 'should get new' do
		get :new
		assert_response :success
	end

	def create_params
		{
			permission: {
				read_record: true,
				write_record: false,
				create_record: false,
				delete_record: false,
				name: "#{@permission.name}_1",
				object_name: @permission.object_name,
				admin: false
			}
		}
	end

	test 'should create permission' do
		assert_difference('Permission.count') do
			post :create, params: create_params
		end

		assert_redirected_to permissions_path
	end

	test 'should create permission returning json' do
		assert_difference('Permission.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should show permission' do
		get :show, params: { id: @permission }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @permission }
		assert_response :success
	end

	def update_params
		{
			id: @permission,
			permission: { name: @permission.name }
		}
	end

	test 'should update permission' do
		patch :update, params: update_params
		assert_redirected_to permissions_path
	end

	test 'should update permission returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy permission' do
		assert_difference('Permission.count', -1) do
			delete :destroy, params: { id: @permission }
		end

		assert_redirected_to permissions_path
	end

	test 'should destroy permission returning json' do
		assert_difference('Permission.count', -1) do
			delete :destroy, params: { id: @permission }, format: :json
		end

		assert_json_success
	end
end
