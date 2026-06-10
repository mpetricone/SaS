module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :resume_session
    before_action :set_current_employee_ivar
    helper_method :current_employee, :authenticated?, :logged_in
  end

  private

  def set_current_employee_ivar
    @current_employee = current_employee
  end

  def authenticated?
    Current.session.present?
  end
  alias_method :logged_in, :authenticated?

  def current_employee
    Current.session&.employee
  end

  def resume_session
    Current.session ||= find_session_by_cookie
  end

  def find_session_by_cookie
    return nil unless cookies.signed[:session_id]
    Session.find_by(id: cookies.signed[:session_id])
  end

  def start_new_session_for(employee)
    employee.sessions.create!(
      user_agent: request.user_agent,
      ip_address: request.remote_ip
    ).tap do |session|
      Current.session = session
      cookies.signed.permanent[:session_id] = {
        value: session.id,
        httponly: true,
        same_site: :lax,
        secure: Rails.env.production? && ENV.fetch("FORCE_SSL", "true") == "true"
      }
    end
  end

  def terminate_session
    Current.session&.destroy
    Current.session = nil
    cookies.delete(:session_id)
  end

  def require_authentication
    return if authenticated?
    flash[:security] = I18n.t(:alert_login_required)
    redirect_to new_session_path
  end
end
