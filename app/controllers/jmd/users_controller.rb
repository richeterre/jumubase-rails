# -*- encoding : utf-8 -*-
class Jmd::UsersController < Jmd::BaseController
  before_filter :require_admin
  
  def index
    @users = User.all
    @title = "Benutzer verwalten"
  end

  def new
    @user = User.new
    @title = "Neuen Benutzer erstellen"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Der Benutzer #{@user.username} ist nun registriert."
      redirect_to jmd_users_path
    else
      @title = "Neuen Benutzer erstellen"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @title = "Benutzer bearbeiten"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:entry])
      flash[:success] = "Der Benutzer #{@user.username} wurde erfolgreich geändert."
      redirect_to jmd_users_path
    else
      @title = "Benutzer bearbeiten"
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "Der Benutzer #{@user.username} wurde gelöscht."
    redirect_to jmd_users_path
  end
end
