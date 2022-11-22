require "test_helper"
require "support/distributer_integration_test_helper"

class DistributerUsageTest < ActionDispatch::IntegrationTest
  include DistributerIntegrationTestHelper

  def setup
    logon_admin
  end

  test "can create distributer" do
    visit_distributers
    page.assert_current_path distributers_path

    click_link "New Distributer"
    fill_in "distributer_name", with: "a name"
    fill_in "Minimum Purchase", with: "1.00"
    fill_in "Minimum Purchase Frequency", with: "5/month"
    fill_in "Date enabled", with: Time::now.strftime(@@date_format)
    fill_in "distributer-contact-search", with: "Surname"
    fill_in "distributer_contact_distributers_attributes_0_description",
      with: "a contact"
    check "Delivery"
    check "Invoice"
    fill_in "Street (line 1)", with: "stln1"
    fill_in "Street (line 2)", with: "stln2"
    fill_in "City", with: "a place"
    fill_in "Postal code", with: "00001"
    fill_in "State", with: "ST"
    fill_in "Country", with: "Belgium"
    fill_in "Status", with: "1"
    within ".card", text: "Distributer Phones" do
      fill_in "Number", with: "987 789-00998"
      fill_in "Description", with: "phone of a guy, or gal"
    end
    within ".card", text: "Distributer E-Mails" do
      fill_in "E-mail", with: "not@an.email"
      fill_in "Description", with: "someone's email"
    end
    click_button "Save"
    assert page.has_content? "Created #{Distributer.model_name.human} "
    page.assert_current_path distributers_path
  end

  test "can edit and use distributer" do
    visit_distributers

    first("a", text: "Edit").click
    page.assert_current_path /\/distributers\/[0-9]*\/edit$/
    assert page.has_content? "Editing "
    click_button "Save"
    assert page.has_content? /Changes to .* saved./
    page.assert_current_path /\/distributers\/[0-9]*$/
    dismiss_notice
    click_link "Return"
    page.assert_current_path /distributers$/
    first("a", text: "Delete").click
    accept_alert /Really delete Distributer.*It's usually best to set the disabled date./
    assert page.has_content? "Removed #{Distributer.model_name.human}"
    first("a", text: "Show").click
    page.assert_current_path /\/distributers\/[0-9]*$/
  end

  test "can use distributer contacts" do
    find_distributer_details

    click_link "New Distributer Contact"
    assert page.has_content? "New Distributer Contact for "
    fill_in "distributer-contact-search", with: "Surname"
    fill_in "Description", with: "a person"
    click_button "Save"
    page.assert_current_path /\/distributers\/[0-9]*/
    assert page.has_content? " added."
    find(".card", text: "Distributer Contacts")
      .first("a", text: "Edit")
      .click
    assert page.has_content? "Edit Distributer Contact for "
    click_button "Save"
    page.assert_current_path /\/distributers\/[0-9]*$/
    assert page.has_content? "#{ContactDistributer.model_name.human} updated."
    find(".card", text: "Distributer Contacts")
      .first("a", text: "Remove")
      .click
    accept_alert "Really delete Distributer Contact?"
    assert page.has_content? "#{ContactDistributer.model_name.human} deleted."
  end

  test "can use distributer address" do
    find_distributer_details

    click_link "New Distributer Address"
    assert page.has_content? "New Distributer Address for "
    check "Delivery"
    check "Invoice"
    fill_in "Street (line 1)", with: "stnl1"
    fill_in "Street (line 2)", with: "stln2"
    fill_in "City", with: "New York"
    fill_in "Postal code", with: "67890"
    fill_in "State", with: "Nowhere"
    fill_in "Country", with: "UK"
    fill_in "Status", with: 2
    click_button "Save"
    page.assert_current_path /\/distributers\/[0-9]*$/
    assert page.has_content? "#{AddressDistributer.model_name.human} added."
    # capy/selenium can't find .card, I see it, not sure what's up
    find("table", text: "Street").
      first("a", text: "Edit")
      .click
    assert page.has_content? "Edit Distributer Address for "
    click_button "Save"
    page.assert_current_path /\/distributers\/[0-9]*$/
    assert page.has_content? "Updated #{AddressDistributer.model_name.human}."
    find("table", text: "Street").
      first("a", text: "Remove")
      .click
    accept_alert "Really delete Distributer Address?"
    assert page.has_content? "Removed #{AddressDistributer.model_name.human}."
  end

  test "can use distributer phone" do
    find_distributer_details

    click_link "New Distributer Phone"
    assert page.has_content? "New Distributer Phone for "
    fill_in "Number", with: "897-000-1234"
    fill_in "Description", with: "a number"
    click_button "Save"
    assert page.has_content? /#{DistributerPhone.model_name.human} .* added./

    find(".card", text: "Distributer Phone")
      .first("a", text: "Edit")
      .click
    assert page.has_content? "Edit Distributer Phone for "
    click_button "Save"
    assert page.has_content? "#{DistributerPhone.model_name.human} updated."

    find(".card", text: "Distributer Phone")
      .first("a", text: "Remove")
      .click
    accept_alert "Really delete Distributer Phone?"
    assert page.has_content? "#{DistributerPhone.model_name.human} removed."
  end
end
