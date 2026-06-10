class Rack::Attack
  # Disabled in test env so the suite isn't throttled when it loops login attempts.
  # Re-enable selectively in tests that exercise the throttle behavior itself.
  Rack::Attack.enabled = !Rails.env.test?

  # In-process memory store. Sufficient for a single-Puma deployment; replace
  # with :solid_cache_store or a Redis-backed store if you scale to multiple
  # app processes.
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # 5 login attempts per IP per 20 seconds
  throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    req.ip if req.path == "/session" && req.post?
  end

  # 5 login attempts per username per 20 seconds
  throttle("logins/username", limit: 5, period: 20.seconds) do |req|
    if req.path == "/session" && req.post?
      req.params.dig("session", "user_name").to_s.strip.downcase.presence
    end
  end

  # 5 password reset requests per IP per hour (path comes online in Phase 4)
  throttle("password_resets/ip", limit: 5, period: 1.hour) do |req|
    req.ip if req.path == "/passwords" && req.post?
  end

  self.throttled_responder = ->(_request) do
    [429, { "Content-Type" => "text/plain" },
     [I18n.t(:alert_throttle, locale: I18n.default_locale)]]
  end
end

# Log throttle events to the audit Log table.
ActiveSupport::Notifications.subscribe("throttle.rack_attack") do |_name, _start, _finish, _id, payload|
  req = payload[:request]
  begin
    Log.create!(
      command: req.request_method,
      category: "rack_attack_throttle",
      module_name: req.env["rack.attack.matched"].to_s,
      in_method: req.path,
      employee_id: nil,
      details: {
        ip: req.ip,
        user_agent: req.user_agent,
        discriminator: req.env["rack.attack.match_discriminator"]
      }.to_json,
      event_at: Time.now
    )
  rescue StandardError => e
    Rails.logger.error "Error logging Rack::Attack throttle: #{e.message}"
  end
end
