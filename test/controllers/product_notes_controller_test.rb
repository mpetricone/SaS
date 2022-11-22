require 'test_helper'

class ProductNotesControllerTest < ActionController::TestCase
	def setup
		@product_note = product_notes(:product_note_1_1)
		@product = products(:product_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { product_id: @product_note.product.id }
		assert_response :success
	end

	def create_params
		{
			product_id: @product.id,
			product_note: {
				title: @product_note.title,
				note: @product_note.note,
				product_id: @product.id
			}
		}
	end

	test 'should create product_note' do
		assert_difference('ProductNote.count') do
			post :create, params: create_params
		end

		assert_redirected_to product_path(assigns(:product))
	end

	test 'should create product_note returning json' do
		assert_difference('ProductNote.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: {
			product_id: @product_note.product.id,
			id: @product_note
		}
		assert_response :success
	end

	def update_params
		{
			product_id: @product_note.product.id,
			id: @product_note,
			product_note: { note: @product_note.note }
		}
	end

	test 'should update product_note' do
		patch :update, params: update_params
		assert_redirected_to product_path(assigns(:product))
	end

	test 'should update product_note returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy product_note' do
		assert_difference('ProductNote.count', -1) do
			delete :destroy, params: { product_id: @product.id, id: @product_note }
		end

		assert_redirected_to product_path(assigns(:product))
	end

	test 'should destroy product_note returning json' do
		assert_difference('ProductNote.count', -1) do
			delete :destroy, params: { product_id: @product.id, id: @product_note }, format: :json
		end

		assert_json_success
	end
end
