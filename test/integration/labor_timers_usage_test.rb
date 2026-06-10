require "test_helper"

class LaborTimersUsageTest < ActionDispatch::IntegrationTest
  self.use_transactional_tests = false

  setup do
    TicketTime.where(running: true).delete_all
    @created_timer_ids = []
    logon_admin
  end

  teardown do
    TicketTime.where(id: @created_timer_ids).delete_all if @created_timer_ids.any?
    TicketTime.where(running: true).delete_all
  end

  test "can navigate to labor timers from main menu" do
    click_link "Main Menu"
    click_link t(:button_labor_timers)
    page.assert_current_path labor_timers_path
    assert page.has_content? t(:title_labor_timers)
  end

  test "shows empty state when no running or stopped timers" do
    visit labor_timers_path
    assert page.has_content? t(:label_no_running_timers)
  end

  test "search by client name lists matching open hourly tickets" do
    visit labor_timers_path
    fill_in "client_name", with: "client_1"
    click_button t(:label_search_short)

    page.assert_current_path %r{/labor_timers}
    assert page.has_content? "client_1"
    assert page.has_link? t(:label_view_ticket)
  end

  test "search with no matching clients shows no-results message" do
    visit labor_timers_path
    fill_in "client_name", with: "nomatch_xyzzy"
    click_button t(:label_search_short)

    assert page.has_content? t(:msg_no_tickets_for_client, client: "nomatch_xyzzy")
  end

  test "displays a running timer card when one exists" do
    ticket = Ticket.find_by(short_description: "description 1")
    timer = TicketTime.create!(
      ticket: ticket,
      employee: Employee.find_by(user_name: "Admin"),
      running: true,
      timer_started_at: 30.minutes.ago
    )
    @created_timer_ids << timer.id

    visit labor_timers_path

    assert page.has_content? t(:label_running_timers)
    assert page.has_content? ticket.client.name
    assert page.has_css?(%([data-controller="labor-timer"][data-labor-timer-running-id-value="#{timer.id}"]))
  end

  test "stop all timers as admin clears running timers" do
    ticket = Ticket.find_by(short_description: "description 1")
    timer = TicketTime.create!(
      ticket: ticket,
      employee: Employee.find_by(user_name: "Admin"),
      running: true,
      timer_started_at: 30.minutes.ago
    )
    @created_timer_ids << timer.id

    visit labor_timers_path

    accept_alert t(:prompt_stop_all_timers) do
      click_link t(:button_stop_all_timers)
    end

    assert page.has_content? t(:notice_all_timers_stopped)
    assert_equal 0, TicketTime.where(running: true).count
  end
end
