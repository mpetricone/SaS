require "test_helper"

class CanUseAddressTest < ActionDispatch::IntegrationTest
  def setup
    logon_admin
  end

  def visit_address_page
    visit addresses_path
  end

  test "can create and use addresses" do
    visit_address_page

    page.assert_current_path addresses_path

    click_link 'New Address'
    page.assert_current_path /\/addresses\/new$/
    fill_in 'Street (line 1)', with: 'line 1'
    fill_in 'Street (line 2)', with: 'Line 2'
    fill_in 'City', with: 'ct'
    fill_in 'Postal code', with: '09876'
    fill_in 'Country', with: 'TZ'
    fill_in 'address_status', with: '1'
    click_button 'Save'
    page.assert_current_path /\/addresses\/[0-9]*$/
    assert page.has_content? /Address .*$/
    click_link 'Return'
    page.assert_current_path addresses_path
    assert has_link? 'Edit'
    first('a', text: 'Edit').click
    page.assert_current_path /\/addresses\/[0-9]*\/edit$/
    fill_in 'Postal code', with: '12345'
    click_button 'Save'
    page.assert_current_path /\/addresses\/[0-9]*$/
    assert page.has_content? /Address .*$/
    click_link 'Return'
    first('a', text: 'Show').click
    page.assert_current_path /\/addresses\/[0-9]*$/
    assert page.has_content? /Address .*$/
    click_link 'Return'
    first('a', text: 'Delete').click
    accept_alert /^Really delete Address .*\?  This could cause deliveries and bills to go missing!$/
    assert page.has_content? "Record destroyed."
  end

  test "cannot create address with missing data" do
    visit_address_page
    click_link "New Address"
    click_button 'Save'

    assert_current_path /\/addresses\/new$/
    assert has_content? "4 Issues preventing Address from being created."
    assert has_content? "Street (line 1) can't be blank"
    assert has_content? "City can't be blank"
    assert has_content? "Postal code can't be blank"
    assert has_content? "Postal code is too short (minimum is 5 characters)"
  end

end
