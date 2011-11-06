# encoding: utf-8
module SessionsHelper
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
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
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  def sign_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  private
    
    def store_location
      session[:return_to] = request.fullpath
    end
    
    def clear_return_to
      session[:return_to] = nil
    end
    
end
