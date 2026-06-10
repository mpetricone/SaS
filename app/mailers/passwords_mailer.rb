class PasswordsMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_FROM", "noreply@example.com")

  def reset(employee)
    @employee = employee
    @token    = employee.generate_token_for(:password_reset)
    mail to: employee.email, subject: t('.subject')
  end
end
