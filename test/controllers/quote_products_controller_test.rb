require 'test_helper'

class QuoteProductsControllerTest < ActionController::TestCase
  def setup
    @quote = quotes(:draft_quote)
    @product = products(:product_5)
    logon_admin
  end

  def teardown
    logout_admin
  end

  test 'new renders' do
    get :new, params: { quote_id: @quote }
    assert_response :success
  end

  test 'create persists a quote_product' do
    assert_difference 'QuoteProduct.count' do
      post :create, params: {
        quote_id: @quote.id,
        quote_product: { product_id: @product.id, price: '12.34', quantity: 2 }
      }
    end
    assert_redirected_to quote_path(@quote)
  end

  test 'create on locked parent quote redirects without saving' do
    accepted = quotes(:accepted_quote)
    assert_no_difference 'QuoteProduct.count' do
      post :create, params: {
        quote_id: accepted.id,
        quote_product: { product_id: @product.id, price: '12.34', quantity: 1 }
      }
    end
    assert_redirected_to quote_path(accepted)
  end

  test 'destroy removes a line' do
    qp = quote_products(:qp_draft_0)
    assert_difference 'QuoteProduct.count', -1 do
      delete :destroy, params: { quote_id: @quote.id, id: qp.id }
    end
    assert_redirected_to quote_path(@quote)
  end
end
