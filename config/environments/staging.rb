require File.expand_path('../production', __FILE__)

Upped::Application.configure do
  config.action_mailer.default_url_options = { host: "staged.upped.me" }
end
