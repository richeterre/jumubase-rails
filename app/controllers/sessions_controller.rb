# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      # Update date of last login
      user.update_attribute(:last_login, DateTime.now)
      # Redirect to originally requested page if applicable, else to root
      redirect_back_or jmd_root_path, notice: "Willkommen, #{user.full_name}! Du bist jetzt angemeldet."
    else
      flash[:error] = "Die E-Mailadresse oder das Passwort war falsch."
      redirect_to signin_path
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
