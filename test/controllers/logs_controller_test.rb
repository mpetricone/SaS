require "test_helper"

class LogsControllerTest < ActionController::TestCase

  def setup
    logon_admin
    @log = logs(:one)
  end

  def teardown
    logout_admin
  end

  test 'should not access page' do
    log_out
    login_useless_user
    get :index
    assert_redirected_to home_index_path
    get :show, params: {id: @log }
    assert_redirected_to home_index_path
    patch :ack, params: { id: @log }
    assert_redirected_to home_index_path
  end


  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:logs)
  end

  test "should get show" do
    get :show, params: {id: @log.id }
    assert_response :success
  end

  test "should set ack" do
    patch :ack, params: {id: @log}
    assert_redirected_to @log
  end

end
