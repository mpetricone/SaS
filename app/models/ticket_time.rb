class TicketTime < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :employee, optional: true

  def update_hours
    self.hours = (self.time_end - self.time_start) / 60 / 60
  end

  def stop_timer!
    now = Time.current
    assign_attributes(
      running: false,
      timer_stopped_at: now,
      date: timer_started_at.to_date,
      time_start: timer_started_at,
      time_end: now,
      hours: (hours.to_f + (now - timer_started_at) / 3600.0).round(4).to_s
    )
    save!
  end
end
