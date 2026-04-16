require 'test_helper'

class AccountsReceivableControllerTest < ActionController::TestCase
  def setup
    logon_admin
  end

  def teardown
    logout_admin
  end
  
  test 'should not access page' do
    log_out
    login_useless_user
    get :index
    assert_redirected_to home_index_path
    post :search, params: { start_data: '', end_date: ''}, xhr: true
    assert_redirected_to home_index_path
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should search' do
    post :search, params: { start_date: '', end_date: '' }, xhr: true
    assert_response :success
  end
end
