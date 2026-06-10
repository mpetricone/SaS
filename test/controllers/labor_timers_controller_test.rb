require 'test_helper'

class LaborTimersControllerTest < ActionController::TestCase
  def setup
    @ticket = tickets(:ticket_1)
    logon_admin
  end

  def teardown
    logout_admin
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get index with client name search' do
    get :index, params: { client_name: 'client' }
    assert_response :success
    assert_not_nil assigns(:search_tickets)
  end

  test 'index assigns running timers' do
    get :index
    assert_not_nil assigns(:running_timers)
  end

  test 'index assigns is_admin true for admin user' do
    get :index
    assert assigns(:is_admin)
  end

  test 'index assigns is_admin false for non-admin user' do
    log_out
    login_useless_user
    get :index
    assert_not assigns(:is_admin)
  end

  test 'should not access index without permission' do
    log_out
    login_useless_user
    get :index
    assert_redirected_to home_index_path
  end

  test 'should stop all timers' do
    @ticket.ticket_times.create!(running: true, timer_started_at: 1.hour.ago, employee: employees(:admin))
    post :stop_all
    assert_redirected_to labor_timers_path
    assert_equal 0, TicketTime.where(running: true).count
  end

  test 'stop_all denied for non-admin' do
    log_out
    login_useless_user
    @ticket.ticket_times.create!(running: true, timer_started_at: 1.hour.ago, employee: employees(:admin))
    post :stop_all
    assert_redirected_to home_index_path
    assert TicketTime.where(running: true).count > 0
  end
end
