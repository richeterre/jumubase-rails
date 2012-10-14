include ApplicationHelper

RSpec::Matchers.define :have_alert_message do |message|
  match do |page|
    page.should have_selector('div.alert')
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error')
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success')
  end
end

RSpec::Matchers.define :have_info_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-info')
  end
end

def sign_in(user)
  fill_in "E-Mail", with: user.email
  fill_in "Passwort", with: user.password
  click_button "Anmelden"
  # Sign in when not using Capybara
  cookies[:remember_token] = user.remember_token
end
