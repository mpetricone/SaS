module Auditor
  SENSITIVE_PARAM_KEYS = %w[password password_confirmation token otp_code recovery_code].freeze

  def auto_log
    user = @current_employee&.id
    begin
      Log.create!(
        command: request.method,
        category: "user action",
        module_name: self.class.name,
        in_method: self.action_name.to_s,
        employee_id: user,
        details: filter_sensitive_params(params).inspect,
        event_at: Time.now
      )
    rescue => e
      Rails.logger.info "Error saving user access: #{e.to_s}"
    end
  end

  def filter_sensitive_params(input)
    case input
    when ActionController::Parameters
      filter_sensitive_params(input.to_unsafe_h)
    when Hash
      input.each_with_object({}) { |(k, v), h| h[k] = filter_sensitive_value(k, v) }
    else
      input
    end
  end

  def filter_sensitive_value(key, value)
    if SENSITIVE_PARAM_KEYS.include?(key.to_s)
      "[FILTERED]"
    elsif value.is_a?(Hash) || value.is_a?(ActionController::Parameters)
      filter_sensitive_params(value)
    else
      value
    end
  end

end
