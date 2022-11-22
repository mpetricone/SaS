require "test_helper"
require "support/ou_integration_test_helper"

class OuUsageTest < ActionDispatch::IntegrationTest
  include OuIntegrationTestHelper

  wp = /\/ous\/[0-9]*$/

  def setup
    logon_admin
  end

  test "can create and use ou" do
    visit_ou_page

    page.assert_current_path ous_path
    click_link 'New OU'
    page.assert_current_path /\/ous\/new$/
    assert page.has_content? 'New OU'
    within '.card', text: 'Primary Info' do
      fill_in 'Ou Name', with: 'newou'
      fill_in 'Description', with: 'an ou'
    end
    within '.card .card', text: 'Address' do
      check 'ou_ou_addresses_attributes_0_delivery'
      check 'ou_ou_addresses_attributes_0_invoice'
      fill_in 'Street (line 1)', with: 'an address'
      fill_in 'Street (line 2)', with: 'adr2'
      fill_in 'City', with: 'Newark'
      fill_in 'Postal code', with: '98765'
      fill_in 'State', with: 'AK'
      fill_in 'Country', with: 'BG'
      fill_in 'Status', with: '1'
    end
    within '.card', text: 'OU Phone' do
      fill_in 'Number', with: '000 224 2244'
      fill_in 'Description', with: 'a number'
    end
    find('.card', text: 'OU E-Mail').fill_in('Address', with: 'email')
    select 'Main', from: 'Root'
    click_button 'Save'
    page.assert_current_path /\/ous\/[0-9]*$/
    assert page.has_content? "Record created"
    dismiss_notice
    click_link 'Return'
    page.assert_current_path ous_path
    first('a', text: 'Edit').click
    page.assert_current_path /\/ous\/[0-9]*\/edit$/
    assert page.has_content? /Editing .*$/
    click_button 'Save'
    page.assert_current_path /\/ous\/[0-9]*$/
    click_link 'Return'
    first('a', text: 'Delete').click
    accept_alert /^Really delete OU .*\?, This is usually not done.$/
    assert page.has_content? "Record Destroyed"
  end

  test "can use ou phone" do
    find_ou_details

    click_link 'New OU Phone'
    page.assert_current_path /\/ous\/[0-9]*\/ou_phones\/new$/
    fill_in 'Number', with: '999 222-9922'
    click_button 'Save'
    page.assert_current_path /\/ous\/[0-9]*$/
    find('.card', text: 'OU Phones')
      .first('a',text: 'Edit')
      .click
    page.assert_current_path /\/ous\/[0-9]*\/ou_phones\/[0-9]*\/edit$/
    assert page.has_content? /^Edit OU Phone for .*$/
    click_button 'Save'
    page.assert_current_path /\/ous\/[0-9]*$/
    find('.card', text: 'OU Phones')
      .first('a', text: 'Remove')
      .click
    accept_alert "Really delete OU Phone?"
    # There's nothing to check
  end

  test "can use ou email" do
    find_ou_details

    click_link 'New OU E-Mail'
    page.assert_current_path /\/ous\/[0-9]*\/ou_emails\/new$/
    assert page.has_content? "New OU E-Mail for "
    fill_in 'Address', with: 'emai@l'
    fill_in 'Description', with: 'whos emai?'
    click_button 'Save'
    page.assert_current_path wp
    assert page.has_content? "E-mail record created"
    find('.card', text: 'OU E-Mail')
      .first('a', text: 'Edit')
      .click
    page.assert_current_path /\/ous\/[0-9]*\/ou_emails\/[0-9]*\/edit$/
    assert page.has_content? "Edit OU E-Mail for "
    click_button 'Save'
    find('.card', text: 'OU E-Mail')
      .first('a',text: 'Remove')
      .click
    accept_alert "Really delete OU E-Mail?"
    assert page.has_content? "#{OuEmail.model_name.human} removed."
  end

  test "can use ou address" do
    find_ou_details

    page.assert_current_path wp

    click_link 'New OU Address'
    page.assert_current_path /\/ous\/[0-9]*\/ou_addresses\/new$/
    assert page.has_content? "New OU Address for "
    check 'Delivery'
    check 'Invoice'
    fill_in 'Street (line 1)', with: 'street'
    fill_in 'Street (line 2)', with: 'street2'
    fill_in 'City', with: 'Jupiter'
    fill_in 'State', with: 'FL'
    fill_in 'Postal code', with: '12345'
    fill_in 'Country', with: 'US'
    fill_in 'Status', with: '1'
    click_button 'Save'
    page.assert_current_path wp
    assert page.has_content? "#{OuAddress.model_name.human} added."
    find('.card', text: 'OU Address')
      .first('a', text: 'Edit')
      .click
    page.assert_current_path /\/ous\/[0-9]*\/ou_addresses\/[0-9]*\/edit$/
    assert page.has_content? 'Edit OU Address for '
    click_button 'Save'
    page.assert_current_path wp
    find('.card', text: 'OU Address')
      .first('a', text: 'Remove')
      .click
    accept_alert 'Really delete OU Address?'
    assert page.has_content? "#{OuAddress.model_name.human} removed." 
  end
end
