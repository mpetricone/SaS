require "test_helper"

class TicketStatusUsageTest < ActionDispatch::IntegrationTest
  def setup
    logon_admin
  end

  test "can use ticket status" do
    visit ticket_statuses_path
    assert_current_path ticket_statuses_path

    click_link 'New Ticket status'
    assert_current_path /\/ticket_statuses\/new$/
    assert has_content? 'New Ticket status'
    fill_in 'Name', with: 'a STATUS'
    click_button 'Save'
    assert_current_path ticket_statuses_path
    assert has_content? /#{TicketStatus.model_name.human} .* created.$/
    click_link 'Edit', match: :first
    assert_current_path /\/ticket_statuses\/[0-9]*\/edit$/
    assert has_content? 'Editing Ticket status'
    click_button 'Save'
    assert_current_path ticket_statuses_path
    assert has_content? /#{TicketStatus.model_name.human} .* updated.$/
    click_link 'Show', match: :first
    assert_current_path /\/ticket_statuses\/[0-9]*$/
    click_link 'Return'
    assert_current_path ticket_statuses_path
    click_link 'Delete', match: :first
    accept_alert /Really delete TicketStatus .*\?$/
    assert has_content? "#{TicketStatus.model_name.human} removed."
  end
end
