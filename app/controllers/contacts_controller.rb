# -*- encoding : utf-8 -*-
class ContactsController < ApplicationController
  def new
    @contact = Contact.new(:id => 1)
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.save
      flash[:success] = "Deine Mitteilung wurde verschickt. Vielen Dank!"
      redirect_to contact_path
    else
      render 'new'
    end
  end
end
