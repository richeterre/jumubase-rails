# -*- encoding : utf-8 -*-
class Jmd::EntriesController < Jmd::BaseController
  helper_method :sort_order 
  
  # Manage entries at hosts the user has access to
  def index
    @title = "Wertungen verwalten"
    @entries = Entry.visible_to(current_user)
                    .joins(:category)
                    .order(sort_order)
  end
  
  def browse
    @title = "Angemeldete Wertungen"
    @entries = Entry.visible_to(current_user)
                    .joins(:category)
                    .category_order
                    .paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @title = "Wertungsdetails"
    @entry = Entry.visible_to(current_user).find(params[:id])
  end
  
  def edit
    @entry = Entry.visible_to(current_user).find(params[:id])
    @title = "Anmeldung bearbeiten"
  end
  
  def update
    @entry = Entry.visible_to(current_user).find(params[:id])
    # Make all attributes accessible to admins
    @entry.accessible = :all if admin?
    if @entry.update_attributes(params[:entry])
      flash[:success] = "Die Anmeldung wurde erfolgreich aktualisiert."
      redirect_to jmd_entries_path
    else
      @title = "Anmeldung bearbeiten"
      render 'edit'
    end
  end
  
  def destroy
    @entry = Entry.find(params[:id]).destroy
    flash[:success] = "Die Wertung wurde gelöscht."
    redirect_to jmd_entries_path
  end
  
  private
    
    def sort_order
      if params[:sort].blank?
        "stage_time"
      else
        params[:sort] + ", stage_time"
      end
    end
end