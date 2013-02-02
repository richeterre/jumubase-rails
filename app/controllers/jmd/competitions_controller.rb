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
                                .select { |p| p.advances_to_next_round? }
    # Split up based on whether the performance already has a successor
    @performances, @already_migrated = @performances.partition { |p| p.successor == nil }

    @possible_target_competitions = @competition.possible_successors.accessible_by(current_ability)
  end

  # Migrate advancing performances to a selected competition
  def migrate_advancing
    # @competition is fetched by CanCan
    target_competition = @competition.possible_successors.find(params[:target_competition_id])

    # Get advancing performances
    @performances = @competition.performances.includes(:appearances, :pieces)
                                .browsing_order
                                .select { |p| p.advances_to_next_round? }
    # Split up based on whether the performance already has a successor
    @performances, already_migrated = @performances.partition { |p| p.successor == nil }

    new_performances = []

    # Collect performances for migration
    @performances.each do |performance|
      new_performance = performance.amoeba_dup # Deep duplicate

      # Remove appearances that don't advance
      new_performance.appearances.each do |appearance|
        new_performance.appearances.delete(appearance) unless appearance.may_advance_to_next_round?
      end

      new_performance.predecessor = performance # Link to predecessor
      new_performances << new_performance # Add to list of performances that will be migrated
    end

    if target_competition.performances << new_performances

      flash[:success] = "#{new_performances.size} \
                         #{Performance.model_name.human(count: new_performances.size)} \
                         wurden erfolgreich nach #{target_competition.name} migriert."
      redirect_to jmd_competition_path(target_competition)
    else
      flash[:error] = "Die Vorspiele konnten nicht migriert werden."
      render 'list_advancing'
    end
  end

  # Send an info email to all participants who advanced to this competition
  def welcome_advanced
    # @competition is fetched by CanCan

    welcome_mail_count = 0

    @competition.performances.includes(:participants).each do |performance|
      performance.participants.each do |participant|
        ParticipantMailer.welcome_advanced(participant, performance).deliver
        welcome_mail_count += 1
      end
    end

    flash[:success] = "#{welcome_mail_count} \
                       #{Participant.model_name.human(count: welcome_mail_count)} \
                       erfolgreich benachrichtigt."
    redirect_to jmd_competition_path(@competition)
  end
end
