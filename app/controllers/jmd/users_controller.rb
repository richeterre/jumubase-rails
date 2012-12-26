# -*- encoding : utf-8 -*-
class Jmd::UsersController < Jmd::BaseController

  load_and_authorize_resource

  # index: @users are fetched by CanCan

  # new: @user is built by CanCan

  def create
    # @user is built by CanCan
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
    # @user is fetched by CanCan
  end

  def edit
    # @user is fetched by CanCan
  end

  def update
    # @user is fetched by CanCan
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
    # @user is fetched by CanCan
    @user.destroy
    flash[:success] = "Der Benutzer #{@user.email} wurde gelöscht."
    redirect_to jmd_users_path
  end
end
