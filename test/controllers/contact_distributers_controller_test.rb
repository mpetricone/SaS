require 'test_helper'

class ContactDistributersControllerTest < ActionController::TestCase
	def setup
		@contact_distributer = contact_distributers(:contact_distributer_1_1)
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
			contact_distributer: {
				distributer_id: @distributer.id,
				contact_id: @contact_distributer.contact.id,
				description: @contact_distributer.description
			}
		}
	end

	test 'should create contact_distributer' do
		assert_difference('ContactDistributer.count') do
			post :create, params: create_params
		end

		assert_redirected_to distributer_path(assigns(:distributer))
	end

	test 'should create contact distributers returning json' do
		assert_difference('ContactDistributer.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: { distributer_id: @distributer.id, id: @contact_distributer }
		assert_response :success
	end

	def update_params
		{
			distributer_id: @distributer.id,
			id: @contact_distributer,
			contact_distributer: {
				description: @contact_distributer.description
			}
		}
	end

	test 'should update contact_distributer' do
		patch :update, params: update_params
		assert_redirected_to distributer_path(assigns(:distributer))
	end

	test 'should update contact distributer returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy contact_distributer' do
		assert_difference('ContactDistributer.count', -1) do
			delete :destroy, params: {
				distributer_id: @distributer.id,
				id: @contact_distributer
			}
		end

		assert_redirected_to distributer_path(assigns(:distributer))
	end

	test 'should destroy contact distributer returning json' do
		assert_difference('ContactDistributer.count', -1) do
			delete :destroy, params: { distributer_id: @distributer, id: @contact_distributer}, format: :json
		end

		assert_json_success
	end
end
