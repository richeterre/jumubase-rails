# encoding: utf-8
module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def signed_in?
    !current_user.nil?
  end

  def admin?
    current_user && current_user.admin?
  end

  def require_admin
    redirect_to root_path unless admin?
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Bitte melde Dich an, um diese Seite zu besuchen."
  end

  def redirect_back_or(default, *args)
    redirect_to(session[:return_to] || default, *args)
    session.delete(:return_to)
  end

  def sign_out
    @current_user = nil
    cookies.delete(:remember_token)
  end

  private

    def store_location
      session[:return_to] = request.fullpath
    end

end
