class AuthenticityToken < ApplicationRecord
  belongs_to :employee
  has_secure_token :token

  def self.generate employee
    auth = AuthenticityToken.new
    auth.employee = employee
    auth.ttl = 600
    auth.time_invalid = DateTime.now + 10.minutes;
    auth.reason = 'login'
    auth.is_valid = true
    return auth
  end

  # generates a new token, resets timer
  def refresh_token 
    regenerate_token
    auth.is_valid = true;
    auth.time_invalid = DateTime.now + ttl.seconds
    return this
  end

end
