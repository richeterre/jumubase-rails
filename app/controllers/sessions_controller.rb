# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController

  def new
    @title = "Login für Organisatoren"
  end
  
  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      # Store user id to create the session
      session[:user_id] = user.id
      # Update date of last login
      user.update_attribute(:last_login, DateTime.now)
      # Redirect to originally requested page if applicable, else to root
      redirect_back_or root_path
    else
      flash.now[:error] = "Der Benutzername oder das Passwort ist falsch."
      @title = "Login für Organisatoren"
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end