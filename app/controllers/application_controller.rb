class ApplicationController < ActionController::Base
  include Auditor
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
	# # modified for API
  protect_from_forgery(with: :exception,  unless: -> { request.format.json? })
  include SessionsHelper

	# this is used on almost every page for the navbar and the home/index as well
	before_action :get_current_employee
  before_action :auto_log
  before_action :skip_session_write_for_search_actions

  # Concurrent AJAX responses can overwrite the session cookie (cookie_store) and
  # clobber a flash that a form POST just set. Read-only search endpoints don't
  # need to persist session state, so skip the Set-Cookie write for them.
  def skip_session_write_for_search_actions
    request.session_options[:skip] = true if action_name == "search_by_name"
  end

	def get_current_employee
		@current_employee= current_employee
	end

	# default responses for json requests
  def json_success
    render json: { response: 'success', error: '' }
  end

  def json_failure reason = false
    render json: { response: 'failure', error: reason }
  end

end
