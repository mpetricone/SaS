class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
	# # modified for API
  protect_from_forgery(with: :exception,  unless: -> { request.format.json? })
  include SessionsHelper

	# this is used on almost every page for the navbar and the home/index as well
	before_action :get_current_employee

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
