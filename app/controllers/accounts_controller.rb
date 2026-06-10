# Per-employee "Account" page reached from the navbar dropdown under the user's
# own name. Currently exposes 2FA management; future profile settings (change
# password, audit own login history, etc.) belong here.
class AccountsController < ApplicationController
  def skip_pundit? = true
  before_action :require_logged_in

  def show
    if current_employee.otp_enabled?
      session.delete(:pending_otp_secret)
    else
      session[:pending_otp_secret] ||= ROTP::Base32.random
      @provisioning_uri = ROTP::TOTP.new(session[:pending_otp_secret], issuer: "SAS")
                                    .provisioning_uri(current_employee.user_name)
      @qr_svg = RQRCode::QRCode.new(@provisioning_uri).as_svg(module_size: 4)
    end
  end

  private

  def require_logged_in
    return if logged_in
    flash[:security] = t(:alert_login_required_account)
    redirect_to new_session_path
  end
end
