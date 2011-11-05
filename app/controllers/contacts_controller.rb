# -*- encoding : utf-8 -*-
class ContactsController < ApplicationController
  def new
    @contact = Contact.new(:id => 1)
    @title = "Kontakt"
  end
  
  def create
    @contact = Contact.new(params[:contact])
    if @contact.save
      flash[:success] = "Deine Mitteilung wurde verschickt."
      redirect_to contact_path
    else
      render 'new'
    end
  end
end
