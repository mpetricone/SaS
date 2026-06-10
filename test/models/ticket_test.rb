require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  setup do
    @ticket = tickets(:ticket_0)
    @employee = employees(:admin)
  end

  # --- invoice_sent? ---

  test "invoice_sent? returns false when payment_requested is false" do
    @ticket.update!(payment_requested: false)
    assert_not @ticket.invoice_sent?
  end

  test "invoice_sent? returns true when payment_requested is true" do
    @ticket.update!(payment_requested: true)
    assert @ticket.invoice_sent?
  end

  # --- has_running_timers? ---

  test "has_running_timers? returns false with no timers" do
    @ticket.ticket_times.destroy_all
    assert_not @ticket.has_running_timers?
  end

  test "has_running_timers? returns false when all timers are stopped" do
    @ticket.ticket_times.destroy_all
    @ticket.ticket_times.create!(running: false, timer_started_at: 1.hour.ago, timer_stopped_at: Time.current, employee: @employee)
    assert_not @ticket.has_running_timers?
  end

  test "has_running_timers? returns true when a timer is running" do
    @ticket.ticket_times.destroy_all
    @ticket.ticket_times.create!(running: true, timer_started_at: 1.hour.ago, employee: @employee)
    assert @ticket.has_running_timers?
  end

  # --- stop_running_timers! ---

  test "stop_running_timers! stops all running timers" do
    @ticket.ticket_times.destroy_all
    2.times { @ticket.ticket_times.create!(running: true, timer_started_at: 1.hour.ago, employee: @employee) }
    @ticket.stop_running_timers!
    assert_not @ticket.has_running_timers?
    @ticket.ticket_times.reload.each do |tt|
      assert_equal false, tt.running
      assert_not_nil tt.timer_stopped_at
    end
  end

  test "stop_running_timers! leaves already-stopped timers unchanged" do
    @ticket.ticket_times.destroy_all
    stopped = @ticket.ticket_times.create!(
      running: false,
      timer_started_at: 2.hours.ago,
      timer_stopped_at: 1.hour.ago,
      employee: @employee
    )
    @ticket.stop_running_timers!
    stopped.reload
    assert_equal false, stopped.running
  end

  # --- calculate_hours! ---

  test "calculate_hours! skips running timer entries" do
    @ticket.ticket_times.destroy_all
    @ticket.ticket_times.create!(running: true, timer_started_at: 1.hour.ago, employee: @employee)
    result = @ticket.calculate_hours!
    assert_equal 0.0, result[:hours]
  end

  test "calculate_hours! uses datetime arithmetic for timer entries" do
    @ticket.ticket_times.destroy_all
    started = 2.hours.ago
    stopped = Time.current
    @ticket.ticket_times.create!(
      running: false,
      timer_started_at: started,
      timer_stopped_at: stopped,
      employee: @employee
    )
    result = @ticket.calculate_hours!
    assert_in_delta 2.0, result[:hours], 0.01
  end

  test "calculate_hours! uses time_of_day arithmetic for manual entries without datetimes" do
    @ticket.ticket_times.destroy_all
    now = Time.current
    @ticket.ticket_times.create!(
      running: false,
      time_start: now,
      time_end: now + 1.5.hours,
      employee: @employee
    )
    result = @ticket.calculate_hours!
    assert_in_delta 1.5, result[:hours], 0.01
  end

  test "calculate_hours! sums multiple stopped entries" do
    @ticket.ticket_times.destroy_all
    now = Time.current
    2.times do
      @ticket.ticket_times.create!(
        running: false,
        timer_started_at: now - 1.hour,
        timer_stopped_at: now,
        employee: @employee
      )
    end
    result = @ticket.calculate_hours!
    assert_in_delta 2.0, result[:hours], 0.05
  end
end
