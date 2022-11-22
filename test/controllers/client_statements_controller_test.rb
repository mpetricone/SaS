require 'test_helper'

class ClientStatementsControllerTest < ActionController::TestCase

  def setup
    @client = clients(:client_1)
    logon_admin
  end

  def teardown
    logout_admin
  end

  test 'should get index' do
    get :index, params: { client_id: @client.id }
    assert_response :success
  end

  test 'should get genenerate xhr' do
    get :generate, params: {client_id: @client.id, start_date: '2001-01-01', end_date: '2019-01-01' }, xhr: true
    assert_response :success
    assert_equal "text/javascript", @response.media_type
  end

#Not sure why this fails. I think it has to do with bad fixture and current_employee helper
  test 'should get generate html' do
    get :generate, params: {client_id: @client.id, start_date: '2001-0101', end_date: '2019-0101' }
    assert_response :success
  end
end
