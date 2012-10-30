# -*- encoding : utf-8 -*-
class Jmd::UsersController < Jmd::BaseController
  before_filter :require_admin # All user actions are admin-only

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Der Benutzer #{@user.email} wurde erstellt."
      redirect_to jmd_users_path
    else
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update_attributes(params[:user])
      flash[:success] = "Der Benutzer #{@user.email} wurde erfolgreich geändert."
      redirect_to jmd_users_path
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "Der Benutzer #{@user.email} wurde gelöscht."
    redirect_to jmd_users_path
  end
end
