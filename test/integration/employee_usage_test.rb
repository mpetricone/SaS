require "test_helper"

class EmployeeUsageTest < ActionDispatch::IntegrationTest
  def setup
    logon_admin
  end

  def visit_employees_page
    visit employees_path
  end

  test "can create and use employee" do
    visit_employees_page

    assert_current_path employees_path
    click_link "New Employee"
    assert_current_path /\/employees\/new$/
    assert has_content? "New Employee"
    fill_in "employee-contact-search", with: "Surn"
    fill_in "User name", with: "surnameWnow"
    fill_in "Password", with: "notpassword"
    fill_in "Confirm Password", with: "notpassword"
    fill_in "Position", with: "any will do"
    fill_in "Date hired", with: 1.day.ago.strftime(@@date_format)
    click_button "Save"
    assert_current_path /\/employees\/[0-9]*/
    assert has_content? "Employee created."
    dismiss_notice
    click_link "Return"
    first("a", text: "Edit").click
    assert_current_path /\/employees\/[0-9]*\/edit$/
    assert has_content? "Editing Employee"
    fill_in "Confirm Password", with: "notpassword"
    click_button "Save"
    assert_current_path /\/employees\/[0-9]*$/
    assert has_content? "Record updated."
    click_link "Return"
    first("a", text: "Delete").click
    accept_alert /Remove Employee .*\?$/
    assert has_content? "Deletion successfull"
  end

  test "can use employee permission" do
    visit employees_path
    first("a", text: "Show").click
    assert_current_path /\/employees\/[0-9]*$/

    click_link "New Employee permission"
    assert_current_path /\/employees\/[0-9]*\/employee_permissions\/new$/
    assert has_content? "New Employee permission for "
    select "permission 1", from: "employee_permission_permission_id"
    click_button "Save"
    assert_current_path /\/employees\/[0-9]*$/
    assert has_content? " granted to "
    find(".card", text: "Employee permission")
      .first("a", text: "Edit")
      .click
    assert_current_path /\/employees\/[0-9]*\/employee_permissions\/[0-9]*\/edit$/
    assert has_content? "Edit Employee permission for "
    click_button "Save"
    assert_current_path /\/employees\/[0-9]*$/
    assert has_css? ".notice-alert", text: "for"
    find(".card", text: "Employee permission")
      .first("a", text: "Remove")
      .click
    accept_alert "Really delete Employee permission?"
    assert has_content? /.* for .* revoked\.$/
  end

  test "cannot create employee with missing data" do
    visit_employees_page
    click_link "New Employee"
    click_button "Save"

    #1st pass for most errors
    assert_current_path /\/employees\/new$/
    assert has_content? "7 Issues preventing Employee from being created."
    assert has_content? "Contact must exist"
    assert has_content? "Contact can't be blank"
    assert has_content? "Position can't be blank"
    assert has_content? "Date hired can't be blank"
    assert has_content? "User name can't be blank"
    assert has_content? "User name is too short (minimum is 6 characters)"
    assert has_content? "Password can't be blank"

    #2nd attempt to check more usename and password failures
    fill_in "Password", with: "anytrhing"
    # this username is expected to exist in test envoirnment
    fill_in "User name", with: "Admin"
    click_button "Save"
    assert_current_path /\/employees\/new$/
    # only check for the new errors.
    assert has_content? "User name has already been taken"
    assert has_content? "Confirm Password doesn't match Password"
  end
end
