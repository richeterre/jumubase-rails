class ApplicationController < ActionController::Base
  protect_from_forgery

  # Tell Devise where to redirect after sign-in
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || jmd_root_path
  end

  # Handle authorization failures
  rescue_from CanCan::AccessDenied do |exception|
    store_location_for :user, request.path

    redirect_to user_signed_in? ? jmd_root_path : new_user_session_path,
      alert: exception.message
  end
end
