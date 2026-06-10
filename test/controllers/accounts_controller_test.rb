require "test_helper"

class AccountsControllerTest < ActionController::TestCase
  setup do
    @admin = employees(:admin)
    log_in @admin
  end

  test "GET show renders the account page with a pending OTP secret when 2FA is disabled" do
    get :show
    assert_response :success
    assert_not_nil session[:pending_otp_secret]
  end

  test "GET show clears any pending OTP secret when 2FA is already enabled" do
    @admin.otp_secret = ROTP::Base32.random
    @admin.otp_enabled = true
    @admin.save!(validate: false)
    session[:pending_otp_secret] = "leftover"
    get :show
    assert_response :success
    assert_nil session[:pending_otp_secret]
  end

  test "an unauthenticated user is redirected to the login page" do
    log_out
    get :show
    assert_redirected_to new_session_path
  end
end
