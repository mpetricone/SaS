require 'test_helper'

class TaxesControllerTest < ActionController::TestCase
	def setup
		@tax = taxes('tax_1')
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:taxes)
	end

	test 'should get index returning json' do
		get :index, format: :json
		assert_response :success
	end

	test 'should search by name' do
		get :search_by_name, params: { search_name: 'tax' }
		assert_response :success
		assert_not_nil assigns(:taxes)
	end

	test 'should search by name returning json' do
		get :search_by_name, params: { search_name: 'tax' }, format: :json
		assert_response :success
		assert_not_nil assigns(:taxes)
	end

	test 'should get new' do
		get :new
		assert_response :success
	end

	def create_params
		{
			tax: {
				name: @tax.name,
				region: @tax.region,
				rate: @tax.rate,
				date_enabled: @tax.date_enabled,
				date_retired: @tax.date_retired
			}
		}
	end

	test 'should create tax' do
		assert_difference('Tax.count') do
			post :create, params: create_params
		end

		assert_redirected_to taxes_path
	end

	test 'should create tax returning json' do
		assert_difference('Tax.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should show tax' do
		get :show, params: { id: @tax }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @tax }
		assert_response :success
	end

	def update_params
		{
			id: @tax,
			tax: { street1: @tax.rate, name: @tax.name }
		}
	end

	test 'should update tax' do
		patch :update, params: update_params
		assert_redirected_to tax_path(assigns(:tax))
	end

	test 'should update tax returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy tax' do
		assert_difference('Tax.count', -1) do
			delete :destroy, params: { id: @tax }
		end

		assert_redirected_to taxes_path(assigns(:taxes))
	end

	test 'should destroy tax returning json' do
		assert_difference('Tax.count', -1) do
			delete :destroy, params: { id: @tax }, format: :json
		end

		assert_json_success
	end
end
