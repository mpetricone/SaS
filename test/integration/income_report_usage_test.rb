require "test_helper"

class IncomeReportUsageTest < ActionDispatch::IntegrationTest
  def setup
    logon_admin
  end

  test "can use income reports" do
    # The dates are reversed to speed the test up
    # a real query was taking much longer than a reasonable timeout
    # on a test enviornment
    # TODO investigate if this operation is an issue in production
    visit income_report_path
    page.assert_current_path income_report_path
    fill_in 'search2_date_start', with:  Time::now.strftime('%m%d%Y')
    fill_in 'search2_date_end', with:  1.year.ago.strftime('%m%d%Y')
    click_button 'Search'
    assert page.has_content? 'Results from'
    assert page.has_content? 'Profit / Loss'
  end
end
