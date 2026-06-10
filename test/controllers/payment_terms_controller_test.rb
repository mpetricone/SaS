require 'test_helper'

class PaymentTermsControllerTest < ActionController::TestCase
  def setup
    @payment_term = payment_terms(:paid_on_completion)
    logon_admin
  end

  def teardown
    logout_admin
  end

  test 'index renders' do
    get :index
    assert_response :success
    assert_not_nil assigns(:payment_terms)
  end

  test 'search_by_name filters' do
    get :search_by_name, params: { search_name: 'Completion' }
    assert_response :success
    names = assigns(:payment_terms).map(&:name)
    assert_includes names, 'Paid on Completion'
    assert_not_includes names, 'Net 30'
  end

  test 'new renders' do
    get :new
    assert_response :success
  end

  test 'create persists' do
    assert_difference 'PaymentTerm.count', 1 do
      post :create, params: { payment_term: { name: 'Test Term', description: 'x', active: true } }
    end
    assert_redirected_to payment_terms_path
  end

  test 'show renders' do
    get :show, params: { id: @payment_term }
    assert_response :success
  end

  test 'edit renders' do
    get :edit, params: { id: @payment_term }
    assert_response :success
  end

  test 'update persists' do
    patch :update, params: { id: @payment_term, payment_term: { name: 'Renamed' } }
    assert_redirected_to payment_term_path(@payment_term)
    assert_equal 'Renamed', @payment_term.reload.name
  end

  test 'destroy removes' do
    assert_difference 'PaymentTerm.count', -1 do
      delete :destroy, params: { id: @payment_term }
    end
    assert_redirected_to payment_terms_path
  end
end
