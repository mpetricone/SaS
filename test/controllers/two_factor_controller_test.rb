require "test_helper"

class TwoFactorControllerTest < ActionController::TestCase
  setup do
    @admin = employees(:admin)
    log_in @admin
  end

  test "POST create with a valid TOTP code enables 2FA and shows recovery codes" do
    secret = ROTP::Base32.random
    session[:pending_otp_secret] = secret
    code = ROTP::TOTP.new(secret).now
    post :create, params: { otp_code: code }
    assert_response :success
    @admin.reload
    assert @admin.otp_enabled?
    assert_equal secret, @admin.otp_secret
    assert_not_nil @admin.otp_recovery_codes
    assert_nil session[:pending_otp_secret]
    assert Log.where(category: "security", in_method: "two_factor_enabled", employee_id: @admin.id).exists?
  end

  test "POST create with a wrong TOTP code redirects back to /account with an alert" do
    secret = ROTP::Base32.random
    session[:pending_otp_secret] = secret
    post :create, params: { otp_code: "000000" }
    assert_redirected_to account_path
    refute @admin.reload.otp_enabled?
  end

  test "DELETE destroy with the correct password disables 2FA and redirects to /account" do
    @admin.otp_secret = ROTP::Base32.random
    @admin.otp_enabled = true
    @admin.save!(validate: false)
    delete :destroy, params: { current_password: "testtest" }
    assert_redirected_to account_path
    refute @admin.reload.otp_enabled?
    assert_nil @admin.otp_secret
    assert Log.where(category: "security", in_method: "two_factor_disabled", employee_id: @admin.id).exists?
  end

  test "DELETE destroy with the wrong password keeps 2FA enabled" do
    @admin.otp_secret = ROTP::Base32.random
    @admin.otp_enabled = true
    @admin.save!(validate: false)
    delete :destroy, params: { current_password: "wrong" }
    assert_redirected_to account_path
    assert @admin.reload.otp_enabled?
  end
end
