require "test_helper"

class AccountsRecievableUsageTest < ActionDispatch::IntegrationTest
  def setup
    logon_admin
  end

  test "can use accounts recievable" do
    visit accounts_receivable_path
    page.assert_current_path accounts_receivable_path
    fill_in 'start_date', with: 1.year.ago.strftime('%m%d%Y')
    fill_in 'end_date', with: Time::now.strftime('%m%d%Y')
    click_button 'Search'
    assert page.has_content? 'Accounts Receivable by Client'
    assert page.has_content? 'Total Receivable: $'
  end
end
