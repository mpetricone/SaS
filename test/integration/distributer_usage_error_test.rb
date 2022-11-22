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

    assert has_content? "6 Issues preventing Distributer from being created."
    assert has_content? "Address distributers address street1 can't be blank"
    assert has_content? "Address distributers address city can't be blank"
    assert has_content? "Address distributers address postal code can't be blank"
    assert has_content? "Address distributers address postal code is too short (minimum is 5 characters)"
    assert has_content? "Contact distributers contact must exist"
    assert has_content? "Name can't be blank"
  end

  test "cannot create distributer address without data" do
   find_distributer_details
  
   click_link "New Distributer Address"
   click_button "Save"

   assert_current_path /\/distributers\/[0-9]*\/address_distributers\/new$/

   assert has_content? "4 Issues preventing Distributer Address from being created."
   assert has_content? "Street (line 1) can't be blank"
   assert has_content? "Address city can't be blank"
   assert has_content? "Address postal code can't be blank"
   assert has_content? "Address postal code is too short (minimum is 5 characters)"

  end
end
