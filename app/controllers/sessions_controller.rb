# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController

  def new
    @title = "Login für Organisatoren"
  end
  
  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
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