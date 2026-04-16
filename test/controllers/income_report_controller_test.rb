require 'test_helper'

class IncomeReportControllerTest < ActionController::TestCase
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
    get :report_v3, params: {
      search2: {
        date_start: Date.today.to_s,
        date_end: (Date.today + 1).to_s
      }
    },
    xhr: true
    assert_redirected_to home_index_path
  end




  test 'should_get_index' do
    get :index
    assert_response :success
  end

  test 'should_get_report' do
    get :report_v3, params: {
      search2: { date_start: Date.today.to_s, date_end: (Date.today + 1).to_s }
    }, xhr: true
    assert_response :success
  end
end
