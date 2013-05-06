require File.expand_path('../production', __FILE__)

Upped::Application.configure do
  # See everything in the log (default is :debug for anything not production)
  config.log_level = :info

  config.action_mailer.default_url_options = { host: "staged.upped.me" }
end
