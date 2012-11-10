# -*- encoding : utf-8 -*-
class Jmd::CompetitionsController < Jmd::BaseController
  before_filter :require_admin # All Competition actions are admin-only

  def index
    @competitions = Competition.order(:begins)
  end

  def new
    @competition = Competition.new
  end

  def create
    @competition = Competition.new(params[:competition])
    if @competition.save
      flash[:success] = "Der Wettbewerb #{@competition.name} wurde erstellt."
      redirect_to jmd_competitions_path
    else
      render 'new'
    end
  end

  def show
    @competition = Competition.find(params[:id])
  end

  def edit
    @competition = Competition.find(params[:id])
  end

  def update
    @competition = Competition.find(params[:id])
    if @competition.update_attributes(params[:competition])
      flash[:success] = "Der Wettbewerb \"#{@competition.name}\" wurde erfolgreich geändert."
      redirect_to jmd_competitions_path
    else
      render 'edit'
    end
  end

  def destroy
    @competition = Competition.find(params[:id]).destroy
    flash[:success] = "Der Wettbewerb \"#{@competition.name}\" wurde gelöscht."
    redirect_to jmd_competitions_path
  end
end
