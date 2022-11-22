require "test_helper"

class ExpenseTypeUsageTest < ActionDispatch::IntegrationTest
  def setup
    logon_admin
  end

  test "can use expense type" do
    visit expense_types_path
    assert_current_path expense_types_path

    click_link 'New Expense Type'
    assert_current_path /\/expense_types\/new$/
    assert has_content? 'New Expense Type'
    fill_in 'Name', with: 'expensive!'
    fill_in 'Description', with: 'exceptionally'
    click_button 'Save'
    assert_current_path expense_types_path
    assert has_content? 'Expense type was successfully created.'
    first('a', text: 'Edit').click
    assert_current_path /\/expense_types\/[0-9]*\/edit$/
    assert has_content? 'Editing Expense Type'
    click_button 'Save'
    assert_current_path /\/expense_types\/[0-9]*/
    assert has_content?  'Expense type was successfully updated.'
    dismiss_notice
    click_link 'Return'
    first('a', text: 'Show').click
    assert_current_path /\/expense_types\/[0-9]*$/
    click_link 'Return'
    assert_current_path expense_types_path
    first('a', text: 'Delete').click
    accept_alert /Really delete Expense Type\? .*/
    assert page.has_content? 'Expense Types cannot be destroyed.' 
  end

  test "cannot create black expense type" do
    visit expense_types_path

    click_link 'New Expense Type'
    click_button 'Save'
    assert_current_path /\/expense_types\/new$/
    assert has_content? "1 Issue preventing Expense Type from being created."
    assert has_content? "Name can't be blank"
  end
end
