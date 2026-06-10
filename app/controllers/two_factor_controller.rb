# Action endpoints for 2FA enrollment / disable. The UI form for these lives
# on AccountsController#show (/account); these endpoints only handle the POST
# (enroll) and DELETE (disable) submissions and redirect back to /account.
class TwoFactorController < ApplicationController
  def skip_pundit? = true
  before_action :require_logged_in

  def create
    secret = session[:pending_otp_secret]
    code   = params[:otp_code].to_s.strip
    if secret.present? && ROTP::TOTP.new(secret).verify(code, drift_behind: 30)
      current_employee.update!(otp_secret: secret, otp_enabled: true)
      @recovery_codes = current_employee.generate_recovery_codes!
      session.delete(:pending_otp_secret)
      Audit.event(:two_factor_enabled, employee: current_employee, request: request)
      render "accounts/two_factor_recovery_codes"
    else
      flash[:alert] = t(:alert_otp_mismatch)
      redirect_to account_path, status: :see_other
    end
  end

  def destroy
    password = params[:current_password].to_s
    if current_employee.authenticate(password)
      current_employee.disable_otp!
      Audit.event(:two_factor_disabled, employee: current_employee, request: request)
      redirect_to account_path, notice: t(:notice_two_factor_disabled)
    else
      redirect_to account_path, alert: t(:alert_password_mismatch)
    end
  end

  private

  def require_logged_in
    return if logged_in
    flash[:security] = t(:alert_login_required_2fa)
    redirect_to new_session_path
  end
end
