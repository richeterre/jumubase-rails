# -*- encoding : utf-8 -*-
class Jmd::JudgesController < Jmd::BaseController
  def index
    # Display all judges the user "owns" through competitions
    @judges = current_user.judges
    @title = "Juroren verwalten"
  end
  
  def new
    @judge = Judge.new
    @title = "Neuen Juror erstellen"
  end
  
  def create
    @judge = Judge.new(params[:judge])
    if @judge.save
      flash[:success] = "Der Juror #{@judge.full_name} wurde erstellt."
      redirect_to jmd_judges_path
    else
      @title = "Neuen Juror erstellen"
      render 'new'
    end
  end
  
  def show
    @judge = Judge.find(params[:id])
    @title = "Wettbewerbsdetails"
  end
  
  def edit
    @judge = Judge.find(params[:id])
    @title = "Juror bearbeiten"
  end
  
  def update
    @judge = Judge.find(params[:id])
    if @judge.update_attributes(params[:judge])
      flash[:success] = "Die Änderungen für #{@judge.full_name} wurden erfolgreich gespeichert."
      redirect_to jmd_judges_path
    else
      @title = "Juror bearbeiten"
      render 'edit'
    end
  end

  def destroy
    @judge = Judge.find(params[:id]).destroy
    flash[:success] = "Der Juror #{@judge.full_name} wurde aus der Jurorenliste entfernt."
    redirect_to jmd_judges_path
  end
end