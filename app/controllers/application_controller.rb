class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  # Use default time unless defined otherwise in controller
  before_filter :reset_timezone
  
  def reset_timezone
    # TODO: Cover current user's time zone prefs here
    Time.zone = Jmd::Application.config.time_zone
  end
end
