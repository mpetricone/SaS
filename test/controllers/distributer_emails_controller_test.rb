require 'test_helper'

class DistributerEmailsControllerTest < ActionController::TestCase
	def setup
		@distributer_email = distributer_emails(:distributer_email_1_1)
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
			distributer_email: {
				distributer: @distributer.id,
				email: @distributer_email.email,
				description: @distributer_email.description
			}
		}
	end

	test 'should create distributer_email' do
		assert_difference('DistributerEmail.count') do
			post :create, params: create_params
		end

		assert_redirected_to distributer_path(assigns(:distributer))
	end

	test 'should create distributer email returning json' do
		assert_difference('DistributerEmail.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: {
			distributer_id: @distributer.id,
			id: @distributer_email
		}
		assert_response :success
	end

	def update_params
		{
			distributer_id: @distributer.id,
			id: @distributer_email,
			distributer_email: { email: @distributer_email.email }
		}
	end

	test 'should update distributer_email' do
		patch :update, params: update_params
		assert_redirected_to distributer_path(assigns(:distributer))
	end

	test 'should update distributer email returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy distributer_email' do
		assert_difference('DistributerEmail.count', -1) do
			delete :destroy, params: {
				distributer_id: @distributer.id,
				id: @distributer_email
			}
		end

		assert_redirected_to distributer_path(assigns(:distributer))
	end

	test 'should destroy distributer email returning json' do
		assert_difference('DistributerEmail.count', -1) do
			delete :destroy, params: { distributer_id: @distributer, id: @distributer_email }, format: :json
		end

		assert_json_success
	end
end
