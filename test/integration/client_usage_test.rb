require "test_helper"
require "support/client_integration_test_helper"

class ClientUsageTest < ActionDispatch::IntegrationTest
  include ClientIntegrationTestHelper

  setup do
    logon_admin
  end

  test "can create and delete client" do
    visit clients_path

    click_link 'New Client'

    assert page.has_content? 'New Client'

    fill_in Client.human_attribute_name(:name), with: 'stuff'
    fill_in 'client-search', with: 'client'

    check 'Delivery'
    check 'Invoice'
    fill_in "Street (line 1)", with: 'stln1'
    fill_in "Street (line 2)", with: 'stln2'
    fill_in 'City', with: "city"
    fill_in 'Postal code', with: '00000-000'
    fill_in 'State', with: "stateorsomesuch"
    fill_in 'Country', with: "sparta"
    fill_in 'Status', with: '1'

    fill_in 'Phone Number', with: '000 999-2283'
    fill_in 'E-Mail', with: 'email@mail.no'

    check 'Current'

    fill_in 'Tax exemption', with: '00-000200'

    click_button 'Save'

    page.assert_current_path clients_path
    assert page.has_content? 'Created record'

    visit clients_path
    first('a', text: 'Delete').click
    accept_alert("Really delete Contact? This could criple the system.")

    assert page.has_content? "Record destroyed"
  end

  test "can edit client" do
    visit clients_path

    first('a', text: 'Edit').click

    page.assert_current_path /\/clients\/[0-9]*\/edit/
    assert page.has_content? 'Editing '
    click_button 'Save'

    page.assert_current_path /\/clients\/[0-9]*/
    assert page.has_content? 'Client Details'
  end

  test "can use client page" do
    find_client

    click_link 'Client Statements'

    page.assert_current_path /\/clients\/[0-9]*\/client_statements/
    
    click_button 'Search'
    assert page.has_content? "Outstanding Invoices"
    assert page.has_content? "Total Due"
    page.go_back

    click_link 'New Ticket'
    page.assert_current_path /\/tickets\/new\?client_id=[0-9]*/
    page.go_back

    click_link 'Edit'
    page.assert_current_path /\/clients\/[0-9]*\/edit/

    page.go_back
    
    click_link 'Return'
    page.assert_current_path clients_path
  end

  test "can use client contacts" do
    find_client_details

    click_link 'New Client Contact'
    assert page.has_content? 'New Client Contact for'
    fill_in "client-contact-search", with: 'Surn'
    click_button 'Save'
    assert page.has_content? ' updated.'

    find('.card', text: 'Client Contacts').first("a", text: 'Edit').click
    assert page.has_content? 'Edit Client Contact for'
    click_button 'Save'
    assert page.has_content? ' updated.'

    find('.card', text: 'Client Contacts').first('a',text: 'Remove').click
    accept_alert 'Really delete Client Contact?'
    assert page.has_content? 'Client Contact deleted.'
  end

  test "can use client addresses" do
    find_client_details

    click_link 'New Client Address'
    assert page.has_content? "New Client Address for "
    check 'Delivery'
    check 'Invoice'
    fill_in 'Street (line 1)', with: 'stln1'
    fill_in 'Street (line 2)', with: 'stln2'
    fill_in 'City', with: 'ct1'
    fill_in 'Postal code', with: '00000'
    fill_in 'Country', with: 'Tanzania'
    fill_in 'State', with: 'ST'
    fill_in 'Status', with: '1'
    click_button 'Save'
    assert page.has_content? " updated"

    find(".card", text: 'Client Address').first('a', text: 'Edit').click
    page.assert_current_path /\/clients\/[0-9]*\/address_clients\/[0-9]*\/edit/
    assert page.has_content? "Edit Client Address for "
    click_button 'Save'
    assert page.has_content? " updated."

    find(".card", text: 'Client Address').first('a', text: 'Remove').click
    accept_alert 'Really delete Client Address?'
    assert page.has_content? 'Client Address record deleted.'
  end

  test "can use client phone" do
    find_client_details

    click_link 'New Client phone'
    assert page.has_content? "New Client phone number for "
    fill_in 'Phone Number', with: '000-999-2938'
    fill_in 'Description', with: 'some info'
    click_button 'Save'
    assert page.has_content? "Updated "

    find(".card", text:  'Client phone').first('a', text: 'Edit').click
    assert page.has_content? "Edit Client phone number for "
    click_button 'Save'
    assert page.has_content? 'Updated '

    find('.card', text: 'Client phone').first('a', text: 'Remove').click
    accept_alert 'Really delete Client phone number?'
    assert page.has_content? "#{ClientPhone.model_name.human} deleted."
  end

  test "can use client email" do
    find_client_details

    click_link 'New Client email'
    assert page.has_content? 'New Client email for '
    fill_in 'E-Mail', with: 'mail@a.place'
    fill_in 'Description', with: 'info'
    click_button 'Save'
    assert page.has_content? " added."

    find('.card', text: 'Client email').first('a', text: 'Edit').click
    assert page.has_content? 'Edit Client email for '
    click_button 'Save'
    assert page.has_content? "#{ClientEmail.model_name.human} updated."

    find('.card', text: 'Client email').first('a', text: 'Remove').click
    accept_alert 'Really delete Client email?'
    assert page.has_content? "#{ClientEmail.model_name.human} deleted."
  end

  test "can_use_client_rate" do
    find_client_details

    click_link 'New Client rate'
    assert page.has_content? "New Client rate for "
    click_button 'Save'
    assert page.has_content? "Added #{ClientRate.model_name.human}."

    find('.card', text: 'Client rate').first('a', text: 'Edit').click
    assert page.has_content? 'Edit Client rate for '
    click_button 'Save'
    assert page.has_content? "Updated #{ClientRate.model_name.human}."
    
    find('.card', text: 'Client rate').first('a', text: 'Remove').click
    accept_alert 'Really delete Client rate?'
    assert page.has_content? "Removed #{ClientRate.model_name.human}."
  end

  test "can use client note" do
    find_client_details

    click_link 'New Client note'
    assert page.has_content? 'New Client note for'
    fill_in 'Title', with: 'a title'
    fill_in 'Note', with: 'some notes'
    click_button 'Save'
    assert page.has_content? "Client note a title added."

    find(".card", text: ClientNote.model_name.human)
      .first('a', text: 'Edit').click
    assert page.has_content? 'Edit Client note for '
    click_button 'Save'
    assert page.has_content?  "#{ClientNote.model_name.human} updated."

    find('.card', text: ClientNote.model_name.human)
      .first('a', text: 'Remove').click
    accept_alert "Really delete Client note?"
    assert page.has_content? "#{ClientNote.model_name.human} deleted."
  end

end
