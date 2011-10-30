# encoding: utf-8
module SessionsHelper
  
  def signed_in?
    true
  end
  
  def current_user
    User.new
  end
  
  class User
    def username
      "Martin"
    end
    
    def admin?
      true
    end
  end
end
