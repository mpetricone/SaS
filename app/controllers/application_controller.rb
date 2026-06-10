class ApplicationController < ActionController::Base
  include Auditor
  include Authentication
  include Pundit::Authorization

  after_action :verify_authorized, unless: :skip_pundit?

  protect_from_forgery with: :exception

  before_action :auto_log
  before_action :skip_session_write_for_search_actions

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Concurrent AJAX responses can overwrite the session cookie (cookie_store) and
  # clobber a flash that a form POST just set. Read-only search endpoints don't
  # need to persist session state, so skip the Set-Cookie write for them.
  def skip_session_write_for_search_actions
    request.session_options[:skip] = true if action_name == "search_by_name"
  end

  # default responses for json requests
  def json_success
    render json: { response: 'success', error: '' }
  end

  def json_failure reason = false
    render json: { response: 'failure', error: reason }
  end

  # Controllers that legitimately don't need authorization opt-in via
  # `def skip_pundit? = true` (auth-bypass paths: login, password reset,
  # 2FA setup/challenge, home, about, reports without role-based gating).
  def skip_pundit?
    false
  end

  private

  def pundit_user
    current_employee
  end

  def user_not_authorized
    if logged_in
      flash[:security] = I18n.t(:alert_permission_denied)
      respond_to do |f|
        f.html { redirect_to (defined?(home_index_path) ? home_index_path : root_path) }
        f.json { render json: { response: 'failure', reason: I18n.t(:alert_permission_denied) } }
      end
    else
      flash[:security] = I18n.t(:alert_login_required)
      respond_to do |f|
        f.html { redirect_to new_session_path }
        f.json { render json: { response: 'failure', reason: I18n.t(:alert_authentication_required) } }
      end
    end
  end
end
