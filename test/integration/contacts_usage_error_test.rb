require "test_helper"
require "support/contact_integration_test_helper"

class ContactsUsageErrorTest < ActionDispatch::IntegrationTest
  include ContactIntegrationTestHelper

  def setup
    logon_admin
  end

  test "cannot create contact with no data" do
    visit contacts_path

    click_link 'New Contact'

    click_button "Save"

    assert_current_path /\/contacts\/new$/

    assert has_css? ".toast-alert"
    assert has_content? "Street (line 1) can't be blank"
    assert has_content? "City can't be blank"
    assert has_content? "Postal code can't be blank"
    assert has_content? "Postal code is too short (minimum is 5 characters)"
    assert has_content? "First Name is too short (minimum is 2 characters)"
    assert has_content? "Last Name is too short (minimum is 2 characters)"
  end

  test "cannot create contact address with no data" do
     find_contact

     click_link 'New Contact Address'

     click_button 'Save'

     assert_current_path /\/contacts\/[0-9]*\/address_contacts\/new$/

     assert has_css? ".toast-alert"
     assert has_content? "Street (line 1) can't be blank"
     assert has_content? "City can't be blank"
     assert has_content? "Postal code can't be blank"
     assert has_content? "Postal code is too short (minimum is 5 characters)"
  end
end
