require 'test_helper'

class AccountsReceivableControllerTest < ActionController::TestCase
  def setup
    logon_admin
  end

  def teardown
    logout_admin
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
