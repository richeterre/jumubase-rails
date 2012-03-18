# -*- encoding : utf-8 -*-
class Jmd::VenuesController < Jmd::BaseController
  before_filter :require_admin # All user actions are admin-only
  
  helper_method :sort_order
  
  def index
    @venues = Venue.joins(:host).order(sort_order)
    @title = "Räume verwalten"
  end

  def new
    @venue = Venue.new
    @title = "Neuen Raum hinzufügen"
  end
  
  def create
    @venue = Venue.new(params[:venue])
    if @venue.save
      flash[:success] = "Der Raum wurde hinzugefügt."
      redirect_to jmd_venues_path
    else
      @title = "Neuen Raum hinzufügen"
      render 'new'
    end
  end

  def edit
    @venue = Venue.find(params[:id])
  end
  
  def update
    @venue = Venue.find(params[:id])
    if @venue.update_attributes(params[:venue])
      flash[:success] = "Der Raum wurde erfolgreich aktualisiert."
      redirect_to jmd_venues_path
    else
      @title = "Raum bearbeiten"
      render 'edit'
    end
  end
  
  def show
    @title = "Raum ansehen"
  end
  
  def destroy
    venue = Venue.find(params[:id]).destroy
    flash[:success] = "Der Raum \"#{venue.name}\" wurde gelöscht."
    redirect_to jmd_venues_path
  end
  
  private
    
    def sort_order
      params[:sort] || "slug"
    end
end
