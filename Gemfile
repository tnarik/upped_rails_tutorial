source 'https://rubygems.org'


gem 'rails', '3.2.11'
gem 'bootstrap-sass'
gem 'bcrypt-ruby'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.6'
gem 'state_machine'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
    gem 'sqlite3'
    gem 'rspec-rails'
    gem 'guard-rspec'
    gem 'guard-spork', :github => 'guard/guard-spork'
    gem 'guard-cucumber'
    gem 'spork', '0.9.2'
end

group :development do
  gem 'annotate'
  gem 'ruby-graphviz', :require => 'graphviz'

  # Deploy with Capistrano
  gem 'rvm-capistrano'
  gem 'capistrano'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :test do
    gem 'capybara', '1.1.2'
    gem 'capybara-webkit'  #for headless testing (requires 'sudo port install qt4-mac' on mac os x lion, and MacPorts 2.1.3)
    gem 'rb-inotify', :require => false
    gem 'rb-fsevent', :require => false
    gem 'rb-fchange', :require => false
    gem 'growl', '1.0.3'

    #tutorial 7
    gem 'factory_girl_rails', '4.1.0'
    #tutorial 8
    gem 'cucumber-rails', '1.2.1', :require => false
    gem 'database_cleaner', '0.7.0'
end

group :production do
    gem 'pg' # For heroku (for Heroku it gets automatically configured)
end
# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# To use debugger
# gem 'debugger'
