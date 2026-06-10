class AddOtpFieldsToEmployees < ActiveRecord::Migration[8.1]
  def change
    # otp_secret and otp_recovery_codes are encrypted at the application layer
    # (Rails attribute encryption). Stored ciphertext can be much longer than
    # the plaintext, so :text is used instead of :string.
    add_column :employees, :otp_secret, :text
    add_column :employees, :otp_enabled, :boolean, default: false, null: false
    add_column :employees, :otp_recovery_codes, :text
  end
end
