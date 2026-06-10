class SessionsController < ApplicationController
  def skip_pundit? = true

  def new
  end

  def create
    user_name = params.dig(:session, :user_name).to_s.strip.downcase
    password  = params.dig(:session, :password).to_s

    employee = Employee.find_by(user_name: user_name)
    authenticated_employee =
      if employee && !employee.locked?
        Employee.authenticate_by(user_name: user_name, password: password)
      end

    respond_to do |format|
      if authenticated_employee && !authenticated_employee.ou.disabled?
        authenticated_employee.reset_failed_attempts!

        if authenticated_employee.otp_enabled?
          # Password OK, but a 2FA challenge is still required. Don't emit
          # login_success yet — TwoFactorChallengeController#create owns that.
          session[:pending_2fa_employee_id] = authenticated_employee.id
          format.html { redirect_to new_two_factor_challenge_path }
          format.json { render json: { response: "two_factor_required" } }
        else
          start_new_session_for(authenticated_employee)
          Audit.event(:login_success, employee: authenticated_employee, request: request)
          format.html { redirect_to root_url, notice: t(:notice_logged_in, name: authenticated_employee.contact.full_name) }
          format.json { render json: { response: "success" } }
        end
      else
        newly_locked = false
        if employee && !employee.locked?
          newly_locked = employee.register_failed_attempt!
        end
        Audit.event(:account_locked, employee: employee, request: request) if newly_locked
        Audit.event(:login_failure,
                    employee: employee,
                    request:  request,
                    details:  { user_name_attempted: user_name, locked: employee&.locked? || false })

        format.html do
          flash.now[:alert] = t(:alert_login_failed)
          render :new, status: :unprocessable_content
        end
        format.json { render json: { response: "fail" } }
      end
    end
  end

  def destroy
    employee_before = current_employee
    terminate_session
    Audit.event(:logout, employee: employee_before, request: request) if employee_before
    respond_to do |format|
      format.html { redirect_to root_url, notice: t(:notice_logged_out) }
      format.json { render json: { response: "success" } }
    end
  end
end
