# encoding: utf-8
module SessionsHelper
  
  def signed_in?
    true
  end
  
  def current_user
    User.new
  end
  
  def admin?
    current_user.admin?
  end
  
  class User
    def username
      "Martin"
    end
    
    def admin?
      false
    end
  end
end
