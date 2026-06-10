require "test_helper"

class PasswordsControllerTest < ActionController::TestCase
  setup do
    @admin = employees(:admin)
    @contact = contacts(:one)
    # Admin's contact has no email by default in fixtures. Add one so the mailer
    # has a recipient to deliver to in the happy-path tests.
    @contact.contact_emails.where(address: "admin@example.test").first_or_create!
    ActionMailer::Base.deliveries.clear
  end

  test "GET new renders the request-reset form" do
    get :new
    assert_response :success
  end

  test "POST create with a valid user_name responds with a generic notice, queues an email, and audits the event" do
    perform_enqueued_jobs do
      post :create, params: { user_name: "Admin" }
    end
    assert_redirected_to new_session_path
    assert_match "If an account exists", flash[:notice]
    assert_equal 1, ActionMailer::Base.deliveries.size
    mail = ActionMailer::Base.deliveries.last
    assert_includes mail.to, "admin@example.test"
    assert Log.where(category: "security", in_method: "password_reset_requested").exists?
  end

  test "POST create with an unknown user_name still responds identically and sends no email" do
    perform_enqueued_jobs do
      post :create, params: { user_name: "totally_fake" }
    end
    assert_redirected_to new_session_path
    assert_match "If an account exists", flash[:notice]
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test "POST create for an employee without any contact_email sends nothing" do
    @contact.contact_emails.destroy_all
    perform_enqueued_jobs do
      post :create, params: { user_name: "Admin" }
    end
    assert_redirected_to new_session_path
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test "GET edit with a valid token renders the change-password form" do
    token = @admin.generate_token_for(:password_reset)
    get :edit, params: { token: token }
    assert_response :success
  end

  test "GET edit with a bogus token redirects to request a new link" do
    get :edit, params: { token: "obviously_invalid" }
    assert_redirected_to new_password_path
    assert_match "invalid or has expired", flash[:alert]
  end

  test "PATCH update with a valid token sets a new password and audits completion" do
    token = @admin.generate_token_for(:password_reset)
    patch :update, params: { token: token, password: "newpassword", password_confirmation: "newpassword" }
    assert_redirected_to new_session_path
    assert @admin.reload.authenticate("newpassword")
    assert Log.where(category: "security", in_method: "password_reset_completed", employee_id: @admin.id).exists?
  end

  test "PATCH update fails when passwords don't match" do
    token = @admin.generate_token_for(:password_reset)
    patch :update, params: { token: token, password: "newpassword", password_confirmation: "different" }
    assert_response :unprocessable_content
    refute @admin.reload.authenticate("newpassword")
  end

  test "a token issued before a password change is invalidated after the change" do
    token = @admin.generate_token_for(:password_reset)
    # Simulate the user resetting via the token successfully.
    patch :update, params: { token: token, password: "newpassword", password_confirmation: "newpassword" }
    # Same token can't be reused — password_digest changed, so generates_token_for invalidates.
    get :edit, params: { token: token }
    assert_redirected_to new_password_path
  end
end
