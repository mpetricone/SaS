require 'test_helper'

class QuoteLaborsControllerTest < ActionController::TestCase
  def setup
    @quote = quotes(:draft_quote)
    logon_admin
  end

  def teardown
    logout_admin
  end

  test 'new renders' do
    get :new, params: { quote_id: @quote }
    assert_response :success
  end

  test 'create fixed labor' do
    assert_difference 'QuoteLabor.count' do
      post :create, params: {
        quote_id: @quote.id,
        quote_labor: { description: 'Test fixed', billing: 'fixed', amount: '99.99' }
      }
    end
    assert_redirected_to quote_path(@quote)
  end

  test 'create hourly labor requires rate and estimated_hours' do
    assert_no_difference 'QuoteLabor.count' do
      post :create, params: {
        quote_id: @quote.id,
        quote_labor: { description: 'Bad hourly', billing: 'hourly' }
      }
    end
    assert_response :unprocessable_content
  end

  test 'create on locked quote redirects without saving' do
    accepted = quotes(:accepted_quote)
    assert_no_difference 'QuoteLabor.count' do
      post :create, params: {
        quote_id: accepted.id,
        quote_labor: { description: 'x', billing: 'fixed', amount: '1.00' }
      }
    end
    assert_redirected_to quote_path(accepted)
  end

  test 'destroy removes a labor line' do
    ql = quote_labors(:ql_draft_fixed)
    assert_difference 'QuoteLabor.count', -1 do
      delete :destroy, params: { quote_id: @quote.id, id: ql.id }
    end
    assert_redirected_to quote_path(@quote)
  end
end
