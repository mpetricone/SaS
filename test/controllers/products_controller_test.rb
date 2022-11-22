require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
	def setup
		@product = products(:product_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get index' do
		get :index
		assert_response :success
		assert_not_nil assigns(:products)
	end

	test 'should get index returning json' do
		get :index, format: :json
		assert_response :success
	end

	test 'should get new' do
		get :new
		assert_response :success
	end

	test 'should search_by_name' do
		get :search_by_name, params: { search_name: 'product' }
		assert_response :success
		assert_not_nil assigns(:products)
	end

	test 'should search_by_name returning json' do
		get :search_by_name, params: { search_name: 'product' }, format: :json
		assert_response :success
		assert_not_nil assigns(:products)
	end

	def create_params
		{
			product: {
				name: "#{@product.name}_1",
				description: @product.description,
				base_cost: @product.base_cost,
				item_number: "#{@product.item_number}_1",
				sku: "#{@product.sku}_1",
				category: @product.category,
				manufacturer: @product.manufacturer
			}
		}
	end

	test 'should create product' do
		assert_difference('Product.count') do
			post :create, params: create_params
		end

		assert_redirected_to product_path(assigns(:product))
	end

	test 'should create product returning json' do
		assert_difference('Product.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should show product' do
		get :show, params: { id: @product }
		assert_response :success
	end

	test 'should get edit' do
		get :edit, params: { id: @product }
		assert_response :success
	end

	def update_params
		{ id: @product, product: { name: @product.name } }
	end

	test 'should update product' do
		patch :update, params: update_params
		assert_redirected_to product_path(assigns(:product))
	end

	test 'should update product returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy product' do
		assert_difference('Product.count', -1) do
			delete :destroy, params: { id: @product }
		end

		assert_redirected_to products_path
	end

	test 'should destroy product returning json' do
		assert_difference('Product.count', -1) do
			delete :destroy, params: { id: @product }, format: :json
		end

		assert_json_success
	end
end
