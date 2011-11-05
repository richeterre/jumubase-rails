# encoding: utf-8
module SessionsHelper
  
  def signed_in?
    false
  end
  
  def current_user
    User.new
  end
  
  def admin?
    current_user.admin?
  end
  
  class User
    def username
      "jumu-user"
    end
    
    def admin?
      false
    end
  end
end
