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
