require 'test_helper'

class OuEmailsControllerTest < ActionController::TestCase
	def setup
		@ou_email = ou_emails(:ou_email_1_1)
		@ou = ous(:ou_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { ou_id: @ou_email.ou.id }
		assert_response :success
	end

	def create_params
		{
			ou_id: @ou.id,
			ou_email: {
				address: @ou_email.address,
				description: @ou_email.description,
				ou_id: @ou.id
			}
		}
	end

	test 'should create ou_email' do
		assert_difference('OuEmail.count') do
			post :create, params: create_params
		end

		assert_redirected_to ou_path(assigns(:ou))
	end

	test 'should create ou_email returning json' do
		assert_difference('OuEmail.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: { ou_id: @ou_email.ou.id, id: @ou_email }
		assert_response :success
	end

	def update_params
		{
			ou_id: @ou_email.ou.id,
			id: @ou_email,
			ou_email: { address: @ou_email.address }
		}
	end

	test 'should update ou_email' do
		patch :update, params: update_params
		assert_redirected_to ou_path(assigns(:ou))
	end

	test 'should update ou_email returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy ou_email' do
		assert_difference('OuEmail.count', -1) do
			delete :destroy, params: { ou_id: @ou.id, id: @ou_email }
		end

		assert_redirected_to ou_path(assigns(:ou))
	end

	test 'should destroy ou_email returning json' do
		assert_difference('OuEmail.count', -1) do
			delete :destroy, params: { ou_id: @ou.id, id: @ou_email }, format: :json
		end

		assert_json_success
	end
end
