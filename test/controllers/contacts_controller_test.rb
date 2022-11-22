require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
	def setup
		@contact = contacts(:one)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:contacts)
	end

	test 'should get index returning json' do
		get :index, format: :json
		assert_response :success
		assert_not_nil assigns(:contacts)
	end

	test 'should get new' do
		get :new
		assert_response :success
	end

	def create_params
		{
			contact: {
				fname: @contact.fname,
				mname: @contact.fname,
				lname: @contact.lname,
				description: @contact.description,
				standing_id: @contact.standing.id
			}
		}
	end

	test 'should create contact' do
		assert_difference('Contact.count') do
			post :create, params: create_params
		end

		assert_redirected_to contact_path(assigns(:contact))
	end

	test 'should create contact returning json' do
		assert_difference('Contact.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should search by name' do
		get :search_by_name, params: { search_by_name: 'contact' }
		assert_response :success
		assert_not_nil assigns(:contacts)
	end

	test 'should search by name returning json' do
		get :search_by_name, params: { search_by_name: 'contact' }, format: :json
		assert_response :success
		assert_not_nil assigns(:contacts)
	end

	test 'should show contact' do
		get :show, params: { id: @contact }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @contact }
		assert_response :success
	end

	def update_params
		{
			id: @contact,
			contact: { fname: @contact.fname }
		}
	end

	test 'should update contact' do
		patch :update, params: update_params
		assert_redirected_to contact_path(assigns(:contact))
	end

	test 'should update contact returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy contact' do
		assert_difference('Contact.count', -1) do
			delete :destroy, params: { id: @contact }
		end

		assert_redirected_to contacts_path
	end

	test 'should destroy contact returning json' do
		assert_difference('Contact.count', -1) do
			delete :destroy, params: { id: @contact }, format: :json
		end

		assert_json_success
	end
end
