# -*- encoding : utf-8 -*-
class Jmd::CompetitionsController < Jmd::BaseController
  before_filter :require_admin # All competition actions are admin-only
  
  def index
    @competitions = Competition.all
    @title = "Wettbewerbe verwalten"
  end

  def new
    @competition = Competition.new
    @title = "Neuen Wettbewerb erstellen"
  end

  def create
    @competition = Competition.new(params[:competition])
    if @competition.save
      flash[:success] = "Der Wettbewerb #{@competition.name} wurde erstellt."
      redirect_to jmd_competitions_path
    else
      @title = "Neuen Wettbewerb erstellen"
      render 'new'
    end
  end
  
  def show
    @competition = Competition.find(params[:id])
    @title = "Wettbewerbsdetails"
  end

  def edit
    @competition = Competition.find(params[:id])
    @title = "Wettbewerb bearbeiten"
  end

  def update
    @competition = Competition.find(params[:id])
    if @competition.update_attributes(params[:competition])
      flash[:success] = "Der Wettbewerb \"#{@competition.name}\" wurde erfolgreich geändert."
      redirect_to jmd_competitions_path
    else
      @title = "Wettbewerb bearbeiten"
      render 'edit'
    end
  end

  def destroy
    @competition = Competition.find(params[:id]).destroy
    flash[:success] = "Der Wettbewerb \"#{@competition.name}\" wurde gelöscht."
    redirect_to jmd_competitions_path
  end
end
