require 'test_helper'

class TicketActionStatusesControllerTest < ActionController::TestCase
  def setup
    @ticket_action_status = ticket_action_statuses(:ticket_action_status_1)
    logon_admin
  end

  def teardown
    logout_admin
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:ticket_action_statuses)
  end

	test 'should search_by_name' do
		get :search_by_name, params: { search_name: 'test' }
		assert_response :success
		assert_not_nil assigns(:ticket_action_statuses)
	end

  test 'should get new' do
    get :new
    assert_response :success
  end
  test 'should create ticket_action_status' do
    assert_difference('TicketActionStatus.count') do
      post :create, params: {
        ticket_action_status: { status: @ticket_action_status.status }
      }
    end

    assert_redirected_to ticket_action_statuses_path
  end

  test 'should show ticket_action_status' do
    get :show, params: { id: @ticket_action_status }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @ticket_action_status }
    assert_response :success
  end

  test 'should update ticket_action_status' do
    patch :update, params: {
      id: @ticket_action_status,
      ticket_action_status: { status: @ticket_action_status.status }
    }
    assert_redirected_to ticket_action_statuses_path
  end

  test 'should destroy ticket_action_status' do
    assert_difference('TicketActionStatus.count', -1) do
      delete :destroy, params: { id: @ticket_action_status }
    end

    assert_redirected_to ticket_action_statuses_path
  end
end
