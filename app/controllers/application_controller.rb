class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  rescue_from CanCan::AccessDenied do |exception|
    store_location
    redirect_to signin_url, alert: exception.message
  end
end
