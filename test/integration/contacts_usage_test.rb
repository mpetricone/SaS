require "test_helper"
require "support/contact_integration_test_helper"

class ContactsUsageTest < ActionDispatch::IntegrationTest
  include ContactIntegrationTestHelper
  # test "the truth" do
  #   assert true
  # end
  setup do
    logon_admin
    assert_home_page
  end


  def is_contact_page?
    page.has_content?('Contact') && page.has_link?('Edit') && page.has_link?('Return')
  end

  test "can delete contact" do
    visit contacts_path

    first('.table .btn-group').click_link 'Delete'
    accept_alert('Really delete Contact?')
    assert page.has_content? 'Contact was successfully destroyed.'
  end

  test "can edit contact" do
    visit contacts_path

    first('.table .btn-group').click_link 'Edit'

    click_button 'Save'

    assert is_contact_page?
    assert page.has_content? 'Contact was successfully updated.'
  end

  test "can_add_contact_email" do
    find_contact

    click_link "New Contact E-Mail"
    fill_in "E-mail Address", with: "an@email.address"
    click_button "Save"

    assert is_contact_page?
    assert page.has_content? 'Contact email was successfully created.'
  end

  test "can edit contact email" do
    find_contact

    find(".card", text: 'Contact E-Mails')
      .find("table tbody")
      .first('tr')
      .click_link 'Edit'

    click_button "Save"

    assert is_contact_page?
    assert page.has_content? 'Contact email was successfully updated.'
  end

  test "can delete contact email" do
    find_contact

    find(".card", text: 'Contact E-Mails')
      .find('table tbody')
      .first('tr')
      .click_link 'Remove'

    accept_alert('Really delete Contact E-Mail?')

    assert page.has_content? 'Contact email was successfully removed.'
  end

  test "can_add_contact_phone_number" do
    find_contact

    click_link "New Contact Phone Number"
    fill_in "Phone number", with: '000 000-0000'
    fill_in "Phone type", with: 'Not a real phone'

    click_button "Save"

    assert is_contact_page?
    assert page.has_content? "Contact phone was succ"
  end

  test "can edit contact phone number" do
    find_contact

    find(".card", text: 'Contact Phone Number')
      .find("table tbody")
      .first("tr")
      .click_link 'Edit'

    click_button "Save"

    assert is_contact_page?
    assert page.has_content? 'Contact phone was successfully updated.'
  end

  test "can remove contact phone number" do
    find_contact

    find(".card", text: 'Contact Phone Number')
      .find("table tbody")
      .first("tr")
      .click_link 'Remove'

    accept_alert('Really delete Contact Phone Number?')

    assert page.has_content? 'Contact phone was successfully removed.'
  end

  test "can_add_contact_address" do
    find_contact

    click_link "New Contact Address"
    check 'Delivery'
    check 'Invoice'

    fill_in "Street (line 1)", with: 'stln1'
    fill_in 'Street (line 2)', with: 'stln2'
    fill_in 'City', with: 'cty'
    fill_in 'Postal code', with: '111111'
    fill_in 'State', with: 'NJ'
    fill_in 'Country', with: 'Indonesia'
    fill_in 'Status', with: '4'

    click_button 'Save'

    assert is_contact_page?
    assert page.has_content? "Added"
  end

  test "can_edit_contact_address" do
    find_contact

    find(".card", text: 'New Contact Address').find("table tbody").first("tr").click_link 'Edit'
    click_button 'Save'

    assert is_contact_page?
    assert page.has_content? 'Updated '
  end

  test "can remove contact address" do
    find_contact

    find(".card", text: 'Contact Addresses').find("tbody").first("tr").click_link 'Remove'

    accept_alert('Really delete Contact Address?')

    assert page.has_content? 'Removed Contact Address'
  end

  test "can_navigate_and_create_user" do
    visit '/'
    click_link 'Main Menu'
    click_link 'Contact'
    page.assert_current_path contacts_path
    click_link 'New Contact'
    page.assert_current_path '/contacts/new'

    fill_in 'First Name', with: 'FN1'
    fill_in 'Last Name', with: 'LN1'
    fill_in 'Middle Name', with: 'MN1'
    fill_in 'Description', with: 'DESC1'

    fill_in 'Phone number', with: '999-999-1234'
    fill_in 'Phone type', with: 'Phone'

    fill_in 'E-mail Address', with: 'em1@em1.em1'


    within '.card .card', text: 'Address' do
      check 'contact_address_contacts_attributes_0_delivery'
      check 'contact_address_contacts_attributes_0_invoice'
      fill_in 'Street (line 1)', with: 'st1'
      fill_in 'Street (line 2)', with: 'st2'
      fill_in 'City', with: 'city'
      fill_in 'Postal code', with: '12345'
      fill_in 'State', with: 'st'
      fill_in 'Country', with: 'ct'
      fill_in 'Status', with: '1'
    end

    click_button 'Save'

    assert page.has_content? 'Contact FN1 LN1'
    assert page.has_link? 'Edit'
    assert page.has_link? 'New Contact Address'
  end

end
