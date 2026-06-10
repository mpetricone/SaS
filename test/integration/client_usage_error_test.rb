require "test_helper"
require "support/client_integration_test_helper"

class ClientUsageErrorTest < ActionDispatch::IntegrationTest
  include ClientIntegrationTestHelper

  def setup
    logon_admin
  end

  test "cannot create client with no data" do
    visit_new_client

    click_button 'Save'

    assert_current_path /\/clients\/new$/
    assert has_css? ".toast-alert"
    assert has_content? "Number can't be blank"
    assert has_content? "E-Mail can't be blank"
    assert has_content? "Street (line 1) can't be blank"
    assert has_content? "City can't be blank"
    assert has_content? "Postal code can't be blank"
    assert has_content? "Postal code is too short (minimum is 5 characters)"
    assert has_content? "Contact can't be blank"
    assert has_content? "Name can't be blank"
  end

  test "cannot create client address with no data" do
    find_client_details

    click_link 'New Client Address'

    click_button 'Save'

    assert_current_path /\/clients\/[0-9]*\/address_clients\/new$/
    assert has_css? ".toast-alert"
    assert has_content? "Street (line 1) can't be blank"
    assert has_content? "City can't be blank"
    assert has_content? "Postal code can't be blank"
    assert has_content? "Postal code is too short (minimum is 5 characters)"
  end

  test "cannot create client phone number with no data" do
    find_client_details

    click_link 'New Client phone number'

    click_button 'Save'

    assert_current_path /\/clients\/[0-9]*\/client_phones\/new$/
    assert has_css? ".toast-alert"
    assert has_content? "Phone Number can't be blank"
  end

  test "cannot create client email with no data" do
    find_client_details

    click_link 'New Client email'

    click_button 'Save'

    assert_current_path /\/clients\/[0-9]*\/client_emails\/new$/
    assert has_css? ".toast-alert"
    assert has_content? "E-Mail can't be blank"
  end
end
