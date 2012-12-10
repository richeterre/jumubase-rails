include ApplicationHelper

# Custom matchers

RSpec::Matchers.define :have_alert_message do |message|
  match do |page|
    page.has_selector?('div.alert')
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.has_selector?('div.alert.alert-error')
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.has_selector?('div.alert.alert-success')
  end
end

RSpec::Matchers.define :have_info_message do |message|
  match do |page|
    page.has_selector?('div.alert.alert-info')
  end
end

# Custom macros

def select_by_id(id, options = {})
  field = options[:from]
  option_xpath = "//*[@id='#{field}']/option[#{id}]"
  option_text = find(:xpath, option_xpath).text
  select option_text, :from => field
end

def select_date(date, options = {})
  field = options[:from]
  select date.year.to_s,   :from => "#{field}_1i"
  select_by_id date.month, :from => "#{field}_2i"
  select date.day.to_s,    :from => "#{field}_3i"
end

def sign_in(user)
  fill_in "dropdown_session_email", with: user.email
  fill_in "dropdown_session_password", with: user.password
  click_button "dropdown_session_submit"
end

def search_for_performance_with_code(tracing_code)
  visit signup_search_path
  fill_in "tracing_code", with: tracing_code
  click_button "Suchen"
end
