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

def select_by_id(id, options = {})
  field = options[:from]
  option_xpath = "//*[@id='#{field}']/option[#{id}]"
  option_text = find(:xpath, option_xpath).text
  select option_text, :from => field
end

# Selecting dates & times from dropdowns
# (adapted from https://gist.github.com/558786)

def select_date(field, options = {})
  date     = options[:with]
  selector = %Q{.//div[contains(./label, "#{field}")]}
  year_string = date.year.to_s
  month_string = I18n.l(date, format: '%B').to_s
  day_string = date.day.to_s

  within(:xpath, selector) do
    find(:xpath, '//select[contains(@id, "_1i")]').find(:xpath, ::XPath::HTML.option(year_string)).select_option
    find(:xpath, '//select[contains(@id, "_2i")]').find(:xpath, ::XPath::HTML.option(month_string)).select_option
    find(:xpath, '//select[contains(@id, "_3i")]').find(:xpath, ::XPath::HTML.option(day_string)).select_option
  end
end

def select_time(field, options = {})
  time     = options[:with]
  selector = %Q{.//div[contains(./label, "#{field}")]}
  within(:xpath, selector) do
    find(:xpath, '//select[contains(@id, "_4i")]').find(:xpath, ::XPath::HTML.option(time.hour.to_s.rjust(2,'0'))).select_option
    find(:xpath, '//select[contains(@id, "_5i")]').find(:xpath, ::XPath::HTML.option(time.min.to_s.rjust(2,'0'))).select_option
  end
end

def select_datetime(field, options = {})
  select_date(field, options)
  select_time(field, options)
end
