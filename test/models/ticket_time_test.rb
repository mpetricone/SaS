require 'test_helper'

class TicketTimeTest < ActiveSupport::TestCase
  setup do
    @ticket = tickets(:ticket_0)
    @employee = employees(:admin)
  end

  test "belongs to employee" do
    tt = TicketTime.new(ticket: @ticket, employee: @employee)
    assert_equal @employee, tt.employee
  end

  test "employee is optional" do
    tt = TicketTime.new(ticket: @ticket)
    assert tt.valid? || tt.errors[:employee].empty?
  end

  test "stop_timer! marks running false" do
    tt = TicketTime.create!(
      ticket: @ticket,
      employee: @employee,
      running: true,
      timer_started_at: 1.hour.ago
    )
    tt.stop_timer!
    assert_equal false, tt.running
  end

  test "stop_timer! sets timer_stopped_at" do
    started = 1.hour.ago
    tt = TicketTime.create!(
      ticket: @ticket,
      employee: @employee,
      running: true,
      timer_started_at: started
    )
    freeze_time do
      tt.stop_timer!
      assert_in_delta Time.current.to_f, tt.timer_stopped_at.to_f, 1.0
    end
  end

  test "stop_timer! calculates hours from datetimes" do
    started = 2.hours.ago
    tt = TicketTime.create!(
      ticket: @ticket,
      employee: @employee,
      running: true,
      timer_started_at: started
    )
    tt.stop_timer!
    assert_in_delta 2.0, tt.hours.to_f, 0.01
  end

  test "stop_timer! sets date from timer_started_at" do
    started = 1.hour.ago
    tt = TicketTime.create!(
      ticket: @ticket,
      employee: @employee,
      running: true,
      timer_started_at: started
    )
    tt.stop_timer!
    assert_equal started.to_date, tt.date
  end

  test "stop_timer! sets time_start and time_end" do
    started = 30.minutes.ago
    tt = TicketTime.create!(
      ticket: @ticket,
      employee: @employee,
      running: true,
      timer_started_at: started
    )
    tt.stop_timer!
    # TIME columns come back anchored to 2000-01-01; compare time-of-day only
    assert_equal started.strftime('%H:%M'), tt.time_start.strftime('%H:%M')
    assert_not_nil tt.time_end
  end

  test "stop_timer! handles midnight crossing correctly" do
    started = Time.current.beginning_of_day - 30.minutes
    tt = TicketTime.create!(
      ticket: @ticket,
      employee: @employee,
      running: true,
      timer_started_at: started
    )
    tt.stop_timer!
    assert tt.hours.to_f > 0, "hours should be positive across midnight"
  end

  test "stop_timer! persists to database" do
    tt = TicketTime.create!(
      ticket: @ticket,
      employee: @employee,
      running: true,
      timer_started_at: 1.hour.ago
    )
    tt.stop_timer!
    reloaded = TicketTime.find(tt.id)
    assert_equal false, reloaded.running
    assert_not_nil reloaded.timer_stopped_at
    assert reloaded.hours.to_f > 0
  end
end
