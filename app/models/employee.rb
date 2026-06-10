class Employee < ActiveRecord::Base
    normalizes :user_name, with: ->(name) { name.to_s.strip.downcase }

    belongs_to :contact
    belongs_to :ou
    has_many :employee_permissions
    has_many :permissions, through: :employee_permissions
    has_many :sessions, dependent: :destroy
		has_many :ticket_expenses, dependent: :nullify
    has_many :tickets
    has_many :ticket_times

    accepts_nested_attributes_for :employee_permissions

    generates_token_for :password_reset, expires_in: 15.minutes do
      password_digest&.last(10)
    end
    validates :ou_id, presence: true
    validates :contact_id, presence: true
    validates :position , presence: true
    validates :date_hired, presence: true
    validates :user_name, presence: true, uniqueness: { case_sensitive: false }
    has_secure_password

    encrypts :otp_secret
    encrypts :otp_recovery_codes

    MAX_FAILED_ATTEMPTS = 10
    LOCKOUT_DURATION    = 30.minutes

    def locked?
      locked_at.present? && locked_at > LOCKOUT_DURATION.ago
    end

    # These three update only internal bookkeeping fields, so they bypass
    # validations on update — legacy employees with short user_names (predating
    # the length validation) must still be lockable and unlockable.
    #
    # Returns true iff this call transitioned the account from unlocked to
    # locked, so callers can emit an Audit.event(:account_locked) without
    # re-checking the locked? state.
    def register_failed_attempt!
      was_locked = locked?
      new_count  = failed_attempts.to_i + 1
      if new_count >= MAX_FAILED_ATTEMPTS
        update_columns(failed_attempts: new_count, locked_at: Time.current)
      else
        update_columns(failed_attempts: new_count)
      end
      !was_locked && reload.locked?
    end

    def reset_failed_attempts!
      return if failed_attempts.to_i.zero? && locked_at.nil?
      update_columns(failed_attempts: 0, locked_at: nil)
    end

    def unlock!
      update_columns(failed_attempts: 0, locked_at: nil)
    end

    def email
      contact&.contact_emails&.first&.address
    end

    # Reads existing data: any permission marked admin grants full access.
    def admin?
      employee_permissions.any? { |ep| ep.permission&.admin }
    end

    # ---- TOTP 2FA ----

    OTP_RECOVERY_CODE_COUNT = 10

    def otp_provisioning_uri
      ROTP::TOTP.new(otp_secret, issuer: "SAS").provisioning_uri(user_name)
    end

    def verify_otp(code)
      return false if otp_secret.blank? || code.blank?
      ROTP::TOTP.new(otp_secret).verify(code.to_s.strip, drift_behind: 30)
    end

    # Returns the array of plaintext recovery codes for one-time display to the
    # user. Stores bcrypt hashes so a DB leak doesn't expose the codes.
    def generate_recovery_codes!
      plain = Array.new(OTP_RECOVERY_CODE_COUNT) { SecureRandom.hex(5) }
      hashes = plain.map { |c| BCrypt::Password.create(c).to_s }
      update!(otp_recovery_codes: JSON.dump(hashes))
      plain
    end

    def consume_recovery_code(code)
      return false if otp_recovery_codes.blank? || code.blank?
      hashes = JSON.parse(otp_recovery_codes)
      matched_index = hashes.find_index { |h| BCrypt::Password.new(h) == code.to_s.strip }
      return false unless matched_index
      hashes.delete_at(matched_index)
      update!(otp_recovery_codes: JSON.dump(hashes))
      true
    end

    def disable_otp!
      update!(otp_enabled: false, otp_secret: nil, otp_recovery_codes: nil)
    end

    def name
        "#{self.contact.full_name}"
    end
end
