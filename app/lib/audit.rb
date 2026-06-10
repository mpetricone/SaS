# Named-event audit logging for security-significant moments.
#
# Usage:
#   Audit.event(:login_success,  employee: e, request: request)
#   Audit.event(:login_failure,  request: request, details: { user_name_attempted: name })
#   Audit.event(:admin_granted,  employee: target, request: request, details: { by: actor.id })
#
# Events land in the same `logs` table that `Auditor#auto_log` uses, but with
# category="security" and module_name="Audit" — so a single query can return
# the security audit trail without scanning the routine request log:
#
#   Log.where(category: "security").order(event_at: :desc)
#   Log.where(category: "security", in_method: "login_failure")
module Audit
  CATEGORY = "security".freeze

  # Defined to make typos surface as exceptions in tests (NameError on an
  # unknown constant) rather than silently logging a misspelled event.
  KNOWN_EVENTS = %i[
    login_success
    login_failure
    account_locked
    account_unlocked
    logout
    password_reset_requested
    password_reset_completed
    two_factor_enabled
    two_factor_disabled
    two_factor_success
    two_factor_failure
    admin_granted
  ].freeze

  def self.event(name, employee: nil, request: nil, details: {})
    raise ArgumentError, "unknown audit event #{name.inspect}" unless KNOWN_EVENTS.include?(name)

    payload = {}
    if request
      payload[:ip]         = request.remote_ip
      payload[:user_agent] = request.user_agent
    end
    payload.merge!(details) if details.is_a?(Hash)

    begin
      Log.create!(
        command:     request&.request_method || "INTERNAL",
        category:    CATEGORY,
        module_name: "Audit",
        in_method:   name.to_s,
        employee_id: employee&.id,
        details:     payload.to_json,
        event_at:    Time.current
      )
    rescue ActiveRecord::ActiveRecordError => e
      # Never let an audit failure break the user-facing flow. ArgumentError
      # above is intentional — typos should surface as test failures, not
      # silent no-ops.
      Rails.logger.error "Audit.event(#{name.inspect}) failed: #{e.class}: #{e.message}"
    end
  end
end
