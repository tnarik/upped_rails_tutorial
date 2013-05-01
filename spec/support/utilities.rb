include ApplicationHelper

def verify_email(user)
  user.activate!
end

def sign_in(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    if message
        page.should have_selector('div.alert.alert-error', text: message)
    else
        page.should have_selector('div.alert.alert-error')
    end
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    if message
        page.should have_selector('div.alert.alert-success', text: message)
    else
        page.should have_selector('div.alert.alert-success')
    end
  end
end