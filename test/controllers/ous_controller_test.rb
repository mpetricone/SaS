require 'test_helper'

class OusControllerTest < ActionController::TestCase
	def setup
		@ou = ous(:one)
    @tax = taxes(:one)
		logon_admin
	end

	def teardown
		# this is causing an issue, I think auth tokens may have been dropped at this point.
		# logout_admin
	end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:ous)
	end

	test 'should get index returning json' do
		get :index, format: :json
		assert_response :success
	end

	test 'should search by name' do
		get :search_by_name, params: { search_name: 'ou' }
		assert_response :success
		assert_not_nil assigns(:ous)
	end

	test 'should search by name returning json' do
		get :search_by_name, format: :json, params: { search_name: 'ou' }
		assert_response :success
	end

	test 'should get new' do
		get :new
		assert_response :success
	end

	def create_params
		{
      ou: { name: @ou.name, description: @ou.description, tax_id: @tax.id }
		}
	end

	test 'should create ou' do
		assert_difference('Ou.count') do
			post :create, params: create_params
		end

		assert_redirected_to ou_path(assigns(:ou))
	end

	test 'should create ou returning json' do
		assert_difference('Ou.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should show ou' do
		get :show, params: { id: @ou }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @ou }
		assert_response :success
	end

	def update_params
    # initially, the tax_id was not necessary in Rails 4-6, but it should have been
    { id: @ou, ou: { name: @ou.name, tax_id: @tax.id }}
	end

	test 'should update ou' do
		patch :update, params: update_params
		assert_redirected_to ou_path(assigns(:ou))
	end

	test 'should update ou returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy ou' do
		assert_difference('Ou.count', -1) do
			delete :destroy, params: { id: @ou }
		end

		assert_redirected_to ous_path
	end

	test 'should destroy ou returning json' do
		assert_difference('Ou.count', -1) do
			delete :destroy, params: { id: @ou }, format: :json
		end

		assert_json_success
	end
end
