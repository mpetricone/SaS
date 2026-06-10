require "test_helper"

class SessionsControllerTest < ActionController::TestCase
  setup do
    @admin = employees(:admin)
  end

  test "GET new renders the login page" do
    get :new
    assert_response :success
  end

  test "POST create with valid credentials starts a session and redirects" do
    post :create, params: { session: { user_name: "Admin", password: "testtest" } }
    assert_redirected_to root_url
    assert_not_nil cookies.signed[:session_id]
    assert Session.exists?(employee: @admin)
    assert Log.where(category: "security", in_method: "login_success", employee_id: @admin.id).exists?
  end

  test "POST create with wrong password renders new with alert and increments failed_attempts" do
    starting = @admin.reload.failed_attempts.to_i
    post :create, params: { session: { user_name: "Admin", password: "wrong" } }
    assert_response :unprocessable_content
    assert_match "Wrong username or password", flash[:alert]
    assert_equal starting + 1, @admin.reload.failed_attempts
    assert Log.where(category: "security", in_method: "login_failure").exists?
  end

  test "POST create with unknown user_name responds with the same generic alert" do
    post :create, params: { session: { user_name: "does_not_exist", password: "anything" } }
    assert_response :unprocessable_content
    assert_match "Wrong username or password", flash[:alert]
  end

  test "successful login resets failed_attempts and clears locked_at" do
    @admin.update_columns(failed_attempts: 3, locked_at: nil)
    post :create, params: { session: { user_name: "Admin", password: "testtest" } }
    assert_redirected_to root_url
    @admin.reload
    assert_equal 0, @admin.failed_attempts
    assert_nil @admin.locked_at
  end

  test "10 failed attempts locks the account and emits account_locked once" do
    Log.where(in_method: "account_locked").delete_all
    Employee::MAX_FAILED_ATTEMPTS.times do
      post :create, params: { session: { user_name: "Admin", password: "wrong" } }
    end
    @admin.reload
    assert @admin.locked?
    assert_not_nil @admin.locked_at
    # exactly one account_locked event — subsequent failed attempts on an
    # already-locked account shouldn't re-emit it.
    assert_equal 1, Log.where(category: "security", in_method: "account_locked", employee_id: @admin.id).count
  end

  test "locked account rejects even the correct password" do
    @admin.update_columns(failed_attempts: Employee::MAX_FAILED_ATTEMPTS, locked_at: Time.current)
    post :create, params: { session: { user_name: "Admin", password: "testtest" } }
    assert_response :unprocessable_content
    assert_nil cookies.signed[:session_id]
  end

  test "lockout expires after LOCKOUT_DURATION" do
    @admin.update_columns(failed_attempts: Employee::MAX_FAILED_ATTEMPTS,
                          locked_at: (Employee::LOCKOUT_DURATION + 1.minute).ago)
    post :create, params: { session: { user_name: "Admin", password: "testtest" } }
    assert_redirected_to root_url
  end

  test "DELETE destroy terminates the session" do
    log_in @admin
    delete :destroy
    assert_redirected_to root_url
    assert_nil cookies.signed[:session_id].presence
    assert Log.where(category: "security", in_method: "logout", employee_id: @admin.id).exists?
  end

  test "login with otp_enabled redirects to 2FA challenge instead of creating session" do
    @admin.update_columns(otp_secret: Employee.connection.quote_string(ROTP::Base32.random))
    # encrypted column needs the model to encrypt — use save with validate: false
    @admin.otp_secret = ROTP::Base32.random
    @admin.otp_enabled = true
    @admin.save!(validate: false)
    post :create, params: { session: { user_name: "Admin", password: "testtest" } }
    assert_redirected_to new_two_factor_challenge_path
    assert_nil cookies.signed[:session_id].presence
    assert_equal @admin.id, session[:pending_2fa_employee_id]
  end
end
