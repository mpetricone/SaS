class PasswordsController < ApplicationController
  def skip_pundit? = true
  before_action :set_employee_by_token, only: [:edit, :update]

  def new
  end

  def create
    user_name = params[:user_name].to_s.strip.downcase
    employee  = Employee.find_by(user_name: user_name)
    if employee&.email.present?
      PasswordsMailer.reset(employee).deliver_later
    end
    Audit.event(:password_reset_requested,
                employee: employee,
                request:  request,
                details:  { user_name_attempted: user_name,
                            account_exists:    !employee.nil?,
                            email_on_file:     employee&.email.present? })
    # Respond identically whether the username exists or has an email to
    # prevent username enumeration.
    redirect_to new_session_path,
      notice: t(:notice_password_reset_sent)
  end

  def edit
  end

  def update
    if @employee.update(params.permit(:password, :password_confirmation))
      Audit.event(:password_reset_completed, employee: @employee, request: request)
      redirect_to new_session_path, notice: t(:notice_password_reset_completed)
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_employee_by_token
    @employee = Employee.find_by_token_for(:password_reset, params[:token])
    redirect_to new_password_path, alert: t(:alert_password_reset_invalid) unless @employee
  end
end
