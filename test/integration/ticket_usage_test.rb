require "test_helper"
require "support/ticket_integration_test_helper"

class TicketsUsageTest < ActionDispatch::IntegrationTest
  include TicketIntegrationTestHelper

  @@path_to_tickets = %r{tickets/[0-9]*}

  setup do
    logon_admin
  end

  test "can edit ticket from index" do
    search_for_ticket

    first("tbody tr .btn-group").click_link "Edit"

    assert page.has_content? t(:title_edit, title: Ticket.model_name.human)

    click_button "Save"

    assert page.has_content? "Updated"
  end

  test "can edit ticket from view" do
    get_ticket_view

    click_link "Edit"
    click_button "Save"

    page.assert_current_path(%r{tickets/[0-9]*})
    assert page.has_content? "updated."
  end

  test "ticket can email client" do
    get_ticket_view

    first("a", text: "@").click

    accept_alert "Send bill to"

    assert page.has_content? "Invoice sent to"
  end

  test "can add and remove ticket type to ticket" do
    get_ticket_view

    [0..2].each do
      click_link "Add #{TicketWorkType.model_name.human}"

      assert page.has_content? t(:title_new, title: TicketWorkType.model_name.human)

      click_button "Save"

      page.assert_current_path @@path_to_tickets
      assert page.has_content? "#{TicketWorkType.model_name.human} added."
    end

    first(".label-badge a").click
    assert page.has_content? "#{TicketWorkType.model_name.human} removed."
  end

  test "can close and open ticket" do
    get_ticket_view
    click_link "Close ticket"
    accept_alert "Close #{Ticket.model_name.human}?"

    assert page.has_content? " closed."

    get_ticket_view true
    click_link "Re-Open ticket"
    accept_alert "Re-Open Ticket"

    assert page.has_content? "Ticket Opened"
  end

  test "can add and remove ticket action to ticket" do
    get_ticket_view

    [0..2].each do
      click_link "Add #{TicketAction.model_name.human}"

      assert page.has_content? t(:title_new, title: TicketAction.model_name.human)

      fill_in TicketAction.human_attribute_name(:action), with: "test action"
      click_button "Save"

      page.assert_current_path @@path_to_tickets
      assert page.has_content? "Added #{TicketAction.model_name.human}."
    end

    first("tr", text: "test action").click_link "Remove"

    accept_alert "Remove #{TicketAction.model_name.human}?"

    assert page.has_content? "Removed #{TicketAction.model_name.human}."
  end

  test "can add and remove merchandise from ticket" do
    get_ticket_view

    click_link "Add #{Product.model_name.human}"

    assert page.has_content? "Adding Merchandise for"

    fill_in "Search Product", with: "prod"

    select "product_1", from: "Product"
    fill_in "Price", with: "10.00"

    click_button "Save"

    assert page.has_content? "added to #{Ticket.model_name.human}"

    first("a", text: "Void").click

    accept_alert "Void sale of"

    assert page.has_content? "removed from #{Ticket.model_name.human}"
  end

  test "can add and remove hours from ticket" do
    get_ticket_view

    click_link "Add Hours"

    assert page.has_content? "Record labor time for"

    click_button "Save"

    assert page.has_content? "#{TicketTime.model_name.human} altered."

    get_ticket_view

    find(".card", text: "Hours Billed").first("tbody tr").click_link "Remove"

    accept_alert "Remove entry?"

    assert page.has_content? "Hours Billed altered."
  end

  test "can add and remove expenses from ticket" do
    get_ticket_view

    click_link "Add Ticket Expense"

    fill_in "ticket_expense_note", with: "a note"
    fill_in "ticket_expense_cost", with: "10.00"
    fill_in "ticket_expense_date_incurred", with: Time.now.strftime("%m%d%Y")

    click_button "Save"

    get_ticket_view

    find(".card", text: "Ticket Expenses").first("tbody tr").click_link "Remove"

    accept_alert "Remove Ticket Expense?"

    assert page.has_content? "Removed Ticket Expense"
  end

  test "can use ticket notes" do
    get_ticket_view

    click_link "Add Ticket note"
    fill_in "ticket_note_subject", with: "a subject"
    fill_in "ticket_note_body", with: "body text"

    click_button "Save"

    assert has_content? "Added Ticket note"

    find("#ticket_notes").first(".btn-group").click_link "Edit"

    click_button "Save"

    assert has_content? "Updated Ticket note"

    find("#ticket_notes").first(".btn-group").click_link "Delete"
    accept_alert "Delete Note"
    assert has_content? "Removed Ticket note"
  end

  test "can use ticket pictures" do
    get_ticket_view

    click_link "Add Ticket Picture"
    fill_in "Description", with: "some text"
    fill_in "Note", with: "a note"

    file_input = find("#ticket_picture_image")
    file_input.send_keys Rails.root.join("test/fixtures/files/tp.png")

    click_button "Save"

    assert has_content? "Image Attached."

    find("#ticket_pictures")
      .first(".btn-group")
      .click_link("Edit")

    click_button "Save"
    assert has_content? "Image Updated."

    find("#ticket_pictures")
    .first(".btn-group")
    .click_link('Delete')

    accept_alert 'Delete Picture?'
    assert has_content? "Image Deleted."
  end

  test "can navigate and create ticket" do
    get_tickets_page

    # search and create ticket
    click_button "Search"
    first("tr").click_link "New Ticket"

    assert page.has_content? t(:title_new, title: Ticket.model_name.human)

    # nothing fancy
    fill_in Ticket.human_attribute_name(:short_description), with: "sd"
    fill_in Ticket.human_attribute_name(:field_location), with: "fl"
    check Ticket.human_attribute_name(:billing_hourly)
    check Ticket.human_attribute_name(:billing_fixed)
    fill_in Ticket.human_attribute_name(:billing_fixed_value), with: "100.00"
    click_button "Save"

    # the rightpage?
    assert page.has_content? t(:sub_title_invoice_payment)
    assert page.has_link? "Edit"
    # the right options?
    assert page.has_content? t(:label_hours_billed)
    assert page.has_content? "Service Cost"
  end
end
