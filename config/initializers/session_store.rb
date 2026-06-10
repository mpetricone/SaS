# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store,
  key:       "_sas_session",
  httponly:  true,
  same_site: :lax,
  secure:    Rails.env.production? && ENV.fetch("FORCE_SSL", "true") == "true"
