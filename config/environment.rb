# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Jmd::Application.initialize!

# Set up mail server
ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address              => "www20.zoner.fi",
  :port                 => 587,
  :user_name            => "jumunordo",
  :password             => "musikverbindet",
  :authentication       => "login",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "jumu-nordost.eu"
# Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?