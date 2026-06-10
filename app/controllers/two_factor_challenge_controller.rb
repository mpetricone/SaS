# Login-time 2FA challenge for employees with otp_enabled?
# SessionsController#create stores :pending_2fa_employee_id in session when the
# password is correct but a TOTP is still required. This controller verifies
# the code, then completes the session.
class TwoFactorChallengeController < ApplicationController
  def skip_pundit? = true
  before_action :load_pending_employee

  def new
  end

  def create
    code = params[:otp_code].to_s.strip

    accepted =
      if @employee.verify_otp(code)
        true
      elsif @employee.consume_recovery_code(code)
        true
      else
        false
      end

    if accepted
      session.delete(:pending_2fa_employee_id)
      start_new_session_for(@employee)
      Audit.event(:two_factor_success, employee: @employee, request: request)
      Audit.event(:login_success,      employee: @employee, request: request)
      redirect_to root_url, notice: t(:notice_logged_in, name: @employee.contact.full_name)
    else
      Audit.event(:two_factor_failure, employee: @employee, request: request)
      flash.now[:alert] = t(:alert_otp_invalid)
      render :new, status: :unprocessable_content
    end
  end

  private

  def load_pending_employee
    id = session[:pending_2fa_employee_id]
    @employee = Employee.find_by(id: id) if id
    return if @employee
    redirect_to new_session_path, alert: t(:alert_relogin_required)
  end
end
