# Rails attribute encryption keys.
#
# Production: must be supplied via environment variables. Generate strong
# values with `bin/rails db:encryption:init` and store them in your secret
# manager / .env / encrypted credentials.
#
# Dev/test: fall back to fixed dummy values so otp_secret / otp_recovery_codes
# round-trip in local development. These are NOT secrets — never use them in
# production.
#
# Build-time exception: during `assets:precompile` the Dockerfile sets
# SECRET_KEY_BASE_DUMMY=1, which tells Rails this boot has no real secrets.
# We honour the same signal here — asset compilation doesn't touch the DB,
# so it's fine to boot with placeholder keys. The real keys are required
# (via ENV.fetch) at runtime when the container actually starts.

if Rails.env.production? && !ENV["SECRET_KEY_BASE_DUMMY"]
  Rails.application.config.active_record.encryption.primary_key         = ENV.fetch("AR_ENCRYPTION_PRIMARY_KEY")
  Rails.application.config.active_record.encryption.deterministic_key   = ENV.fetch("AR_ENCRYPTION_DETERMINISTIC_KEY")
  Rails.application.config.active_record.encryption.key_derivation_salt = ENV.fetch("AR_ENCRYPTION_KEY_DERIVATION_SALT")
else
  Rails.application.config.active_record.encryption.primary_key         = "dev_primary_key_at_least_32_characters_long"
  Rails.application.config.active_record.encryption.deterministic_key   = "dev_deterministic_key_at_least_32_chars"
  Rails.application.config.active_record.encryption.key_derivation_salt = "dev_salt_at_least_32_characters_long_for_testing"
end
