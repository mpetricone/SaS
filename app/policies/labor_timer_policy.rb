class LaborTimerPolicy < ApplicationPolicy
  permission_name :ticket_attribute

  # Legacy behavior: stop_all gated on read perm (not write).
  def stop_all? = read?
end
