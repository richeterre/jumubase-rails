# -*- encoding : utf-8 -*-
class Jmd::CompetitionsController < Jmd::BaseController

  load_and_authorize_resource # CanCan

  def index
    # @competitions are fetched by CanCan
    @competitions = @competitions.includes(:host, :round).order(:begins)
  end

  # new: @competition is built by CanCan

  def create
    # @competition is built by CanCan
    if @competition.save
      flash[:success] = "Der Wettbewerb #{@competition.name} wurde erstellt."
      redirect_to jmd_competitions_path
    else
      render 'new'
    end
  end

  # show: @competition is fetched by CanCan

  # edit: @competition is fetched by CanCan

  def update
    # @competition is fetched by CanCan
    if @competition.update_attributes(params[:competition])
      flash[:success] = "Der Wettbewerb \"#{@competition.name}\" wurde erfolgreich geändert."
      redirect_to jmd_competitions_path
    else
      render 'edit'
    end
  end

  def destroy
    # @competition is fetched by CanCan
    @competition.destroy
    flash[:success] = "Der Wettbewerb \"#{@competition.name}\" wurde gelöscht."
    redirect_to jmd_competitions_path
  end

  # List performances that advance to the next round
  def list_advancing
    # @competition is fetched by CanCan
    @performances = @competition.performances
                                .browsing_order
                                .select { |p| p.appearances.any? { |a| a.may_advance_to_next_round? }}
    @possible_target_competitions = @competition.possible_successors.accessible_by(current_ability)
  end

  # Migrate advancing performances to a selected competition
  def migrate_advancing
    # @competition is fetched by CanCan
    target_competition = @competition.possible_successors.find(params[:target_competition_id])

    # Get advancing performances
    @performances = @competition.performances
                                .browsing_order
                                .select { |p| p.appearances.any? { |a| a.may_advance_to_next_round? }}

    # Migrate each performance
    @performances.each do |performance|
      new_performance = performance.amoeba_dup
      target_competition.performances << new_performance
    end
  end
end
