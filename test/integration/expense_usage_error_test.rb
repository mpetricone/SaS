require "test_helper"
require "support/expense_integration_test_helper"

class ExpenseUsageErrorTest < ActionDispatch::IntegrationTest
  include ExpenseIntegrationTestHelper

  def setup
    logon_admin
  end

  test "cannot create expense without data" do
    visit_expenses_page

    click_link 'New Expense'

    click_button 'Save'

    assert_current_path /\/expenses\/new$/

    assert has_content? "3 Issues preventing Expense from being created."
    assert has_content? "Name can't be blank"
    assert has_content? "Cost can't be blank"
    assert has_content? "Cost is not a number"
  end

  test "cannot create expense payment without data" do
    find_expense_page

     click_link 'New Expense Payment'

     click_button 'Save'

     assert_current_path /\/expenses\/[0-9]*\/expense_payments\/new$/

     assert has_content? "2 Issues preventing Expense Payment from being recorded."
     assert has_content? "Amount can't be blank"
     assert has_content? "Amount is not a number"
  end
end
