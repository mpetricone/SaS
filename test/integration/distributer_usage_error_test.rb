require "test_helper"
require "support/distributer_integration_test_helper"

class DistributerUsageErrorTest < ActionDispatch::IntegrationTest
  include DistributerIntegrationTestHelper

  def setup
    logon_admin
  end

  test "cannot create distributer without data" do
    visit_distributers

    click_link "New Distributer"
    click_button "Save"

    assert_current_path /\/distributers\/new$/
    assert has_css? ".toast-alert"
    assert has_content? "Street (line 1) can't be blank"
    assert has_content? "City can't be blank"
    assert has_content? "Postal code can't be blank"
    assert has_content? "Postal code is too short (minimum is 5 characters)"
    assert has_content? "Contact can't be blank"
    assert has_content? "Name can't be blank"
  end

  test "cannot create distributer address without data" do
    find_distributer_details

    click_link "New Distributer Address"
    click_button "Save"

    assert_current_path /\/distributers\/[0-9]*\/address_distributers\/new$/
    assert has_css? ".toast-alert"
    assert has_content? "Street (line 1) can't be blank"
    assert has_content? "City can't be blank"
    assert has_content? "Postal code can't be blank"
    assert has_content? "Postal code is too short (minimum is 5 characters)"
  end
end
