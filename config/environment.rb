# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Upped::Application.initialize!

Rails.application.routes.default_url_options[:host] = 'localhost:3000' unless Rails.application.routes.default_url_options[:host].present?