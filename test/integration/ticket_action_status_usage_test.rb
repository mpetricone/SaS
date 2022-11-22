require "test_helper"

class TicketActionStatusUsageTest < ActionDispatch::IntegrationTest
  def setup
    logon_admin
  end

  test "can use ticket action status" do
    visit ticket_action_statuses_path
    assert_current_path ticket_action_statuses_path

    click_link 'New Ticket action status'
    assert has_content? 'New Ticket action status'
    fill_in 'Status', with: '100% AOK'
    click_button 'Save'
    assert_current_path ticket_action_statuses_path
    assert has_content?( /\ added.$/)
    first('a', text: 'Edit').click
    assert_current_path /\/ticket_action_statuses\/[0-9]*\/edit$/
    assert has_content? 'Editing Ticket action status'
    click_button 'Save'
    assert_current_path ticket_action_statuses_path
    assert has_content? /\ modified$/
    first('a', text: 'Show').click
    assert_current_path /\/ticket_action_statuses\/[0-9]*$/
    click_link 'Return'
    first('a', text: 'Delete').click
    accept_alert /Really delete Ticket action status .*\? This could break many Tickets.$/
    assert has_content? "#{TicketActionStatus.model_name.human} removed."
  end
end
