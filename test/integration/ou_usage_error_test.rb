require "test_helper"
require "support/ou_integration_test_helper"

class OusUsageErrorTest < ActionDispatch::IntegrationTest
  include OuIntegrationTestHelper

  def setup
    logon_admin
  end

  test "cannot add ou with missing data" do
    visit_ou_page
    click_link "New OU"
    click_button "Save"

    assert_current_path /\/ous\/new$/
    assert has_content? "7 Issues preventing OU from being created."
    assert has_content? "Ou addresses address street1 can't be blank"
    assert has_content? "Ou addresses address city can't be blank"
    assert has_content? "Ou addresses address postal code can't be blank"
    assert has_content? "Ou addresses address postal code is too short (minimum is 5 characters)"
    assert has_content? "Ou phones number can't be blank"
    assert has_content? "Ou emails address can't be blank"
    assert has_content? "Ou Name can't be blank"
  end

  test "cannot create blank ou phone" do
    find_ou_details

    click_link "New OU Phone"
    click_button 'Save'
    
    assert_current_path /\/ous\/[0-9]*\/ou_phones\/new$/
    
    assert has_content? "1 Issue preventing OU Phone from being created."
    assert has_content? "Number can't be blank"
  end
  
  test "cannot create blank ou email" do
    find_ou_details

    click_link 'New OU E-Mail'
    click_button 'Save'

    assert_current_path /\/ous\/[0-9]*\/ou_emails\/new$/
    assert has_content? "1 Issue preventing OU E-Mail from being created."
    assert has_content? "Address can't be blank"
  end

  test "cannot create ou address with missing data" do
    find_ou_details

    click_link 'New OU Address'
    click_button 'Save'

    assert_current_path /\/ous\/[0-9]*\/ou_addresses\/new$/
    assert has_content? "4 Issues preventing OU Address from being created."
    assert has_content? "Street (line 1) can't be blank"
    assert has_content? "Address city can't be blank"
    assert has_content? "Address postal code can't be blank"
    assert has_content? "Address postal code is too short (minimum is 5 characters)"
  end
end
