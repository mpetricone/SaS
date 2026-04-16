module Auditor
  @@type_success = "SUCCESS"
  @@type_fail = "FAIL"

  def log_success request, details
    log request, @@type_success, caller_locations(1, 1)[0].label, details
  end

  def log_failure request, details
    log request, @@type_fail, caller_locations(1, 1)[0].label, details
  end

  def auto_log
    user = nil
    if @current_employee
      user = @current_employee.id
    end
    begin
      Log.create!(
        command: request.method,
        category: "user action",
        module_name: self.to_s,
        in_method: self.action_name.to_s,
        employee_id: user,
        details: params.inspect,
        event_at: Time.now
      )
    rescue  => e
      Rails.logger.info "Error saving user access: #{e.to_s}" 
    end
  end

  def log request, category, method, details

    begin
      Log.create!(
        command: request.method, 
        category: category, 
        module_name: self.to_s, 
        in_method: method, 
        employee_id: @current_employee.id, 
        details: details.to_json,
        event_at: Time.now);
    rescue ActiveRecord::RecordInvalid
      Rails.logger.error "Error saving audit event:  #{request.inspect}, #{method.inspect}, #{@current_employee.id}, #{details}, #{log_type}" 
    end
  end

end
