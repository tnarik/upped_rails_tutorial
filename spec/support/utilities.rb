include ApplicationHelper

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
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