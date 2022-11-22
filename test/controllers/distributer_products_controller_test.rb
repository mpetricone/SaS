require 'test_helper'

class DistributerProductsControllerTest < ActionController::TestCase
	def setup
		@distributer_product = distributer_products(:distributer_product_1_1)
		@product = products(:product_1)
		@product2 = products(:product_alt)
		logon_admin
	end

	def teardown
		logout_admin
	end

	test 'should get new' do
		get :new, params: { product_id: @distributer_product.product.id }
		assert_response :success
	end

	test 'should not duplicate distributer_product' do
		assert_difference('DistributerProduct.count', 0) do
			post :create, params: {
				product_id: @product.id,
				distributer_product: {
					distributer_id: @distributer_product.distributer_id,
					product_id: @distributer_product.product_id,
					current_cost: @distributer_product.current_cost,
					dist_item_number: "#{@distributer_product.dist_item_number}_1"
				}
			}
		end

	end

	def create_params
		{
			product_id: @product2.id,
			distributer_product: {
				distributer_id: @distributer_product.distributer.id,
				product_id: @product2.id,
				current_cost: @product2.base_cost.to_f().round(2)+10,
				dist_item_number: "#{@distributer_product.dist_item_number}_1"
			}
		}
	end

	test 'should create distributer_product' do
		assert_difference('DistributerProduct.count') do
			post :create, params: create_params
		end

		assert_redirected_to product_path(assigns(:product))
	end

	test 'should create distributer product returning json' do
		assert_difference('DistributerProduct.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

	test 'should get edit' do
		get :edit, params: {
			product_id: @distributer_product.product.id,
			id: @distributer_product
		}
		assert_response :success
	end

	def update_params
		{
			product_id: @distributer_product.product.id,
			id: @distributer_product,
			distributer_product: { current_cost: @distributer_product.current_cost }
		}
	end

	test 'should update distributer_product' do
		patch :update, params: update_params
		assert_redirected_to product_path(assigns(:product))
	end

	test 'should update distributer product returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy distributer_product' do
		assert_difference('DistributerProduct.count', -1) do
			delete :destroy, params: {
				product_id: @product.id,
				id: @distributer_product
			}
		end

		assert_redirected_to product_path(assigns(:product))
	end

	test 'should destroy distributer product returning json' do
		assert_difference('DistributerProduct.count', -1) do
			delete :destroy, params: { product_id: @product, id: @distributer_product }, format: :json
		end

		assert_json_success
	end
end
