require "test_helper"
require "selenium-webdriver"
require "support/expense_integration_test_helper"

class ExpenseUsageTest < ActionDispatch::IntegrationTest
  include ExpenseIntegrationTestHelper

  setup do
    logon_admin
  end

  test "can visit and create new expense" do
    visit_expenses_page
    page.assert_current_path "/expenses"

    click_link "New Expense"
    fill_in "expense_name", with: "an expensive thing"
    fill_in "Cost", with: "100.00"
    fill_in "Invoice number", with: "101010101010"
    fill_in "expense_description", with: 'well it wasn\'t so  expensive after all'
    click_button "Save"
    page.assert_current_path /\/expenses\/[0-9]*/
    assert page.has_content? "Expense was successfully created."

    dismiss_notice
    click_link "Return"
    page.assert_current_path "/expenses"
  end

  test "can use and edit expenses" do
    visit_expenses_page

    first("a", text: "Show").click
    assert page.has_content? "Expense Payment"
    click_link "Return"
    page.assert_current_path expenses_path
    first("a", text: "Edit").click
    assert page.has_content? "Editing Expense"
    click_button "Save"
    assert page.has_content? "Expense was successfully updated."
    click_link "Return"
    page.assert_current_path expenses_path
    first("a", text: "Delete").click
    accept_alert "Delete Expense"
    assert page.has_content? "Expense was successfully destroyed."
  end

  test "can use expense payments" do
    find_expense_page

    click_link "New Expense Payment"
    assert page.has_content? "New Expense Payment for "
    fill_in "Amount", with: "10.00"
    fill_in "Identifier", with: "ident"
    select "MyString", from: "Ou payment type"
    click_button "Save"
    assert page.has_content? "Expense payment was successfully created."
    find(".card", text: "Expense Payment").first("a", text: "Edit").click
    assert page.has_content? "Edit Expense Payment for "
    click_button "Save"
    assert page.has_content? "Expense payment was successfully updated."
    find(".card", text: "Expense Payment").first("a", text: "Remove").click
    accept_alert "Really delete Expense Payment?"
    assert page.has_content? "Expense payment was successfully removed."
  end
end
