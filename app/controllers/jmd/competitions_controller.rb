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

  # Schedule classical performance stage times
  def schedule_classical
    # @competition is fetched by CanCan
    @performances = @competition.performances
                                .includes(:predecessor, :participants)
                                .classical.browsing_order
    @categories = Category.classical.current
  end

  # Schedule popular performance stage times
  def schedule_popular
    # @competition is fetched by CanCan
    @performances = @competition.performances
                                .includes(:predecessor, :participants)
                                .popular.browsing_order
    @categories = Category.popular.current
  end

  # List performances that advance to the next round
  def list_advancing
    # @competition is fetched by CanCan

    if @competition.can_be_advanced_from?
      load_migration_resources # Loads possible target competitions, migratable performances and already migrated
    else
      flash[:error] = "Aus diesem Wettbewerb können leider keine Vorspiele weitergeleitet werden."
      redirect_to jmd_competition_path(@competition)
    end
  end

  # Migrate advancing performances to a selected competition
  def migrate_advancing
    # @competition is fetched by CanCan

    load_migration_resources # Loads possible target competitions, migratable performances and already migrated
    target_competition = @possible_target_competitions.find(params[:target_competition_id]) # Load selected target

    # Collect performances for migration
    new_performances = []
    @performances.each do |performance|
      new_performance = performance.amoeba_dup # Deep duplicate

      # Remove appearances that don't advance
      # This is buggy when not deleting all at once, probably due to coupling during age group calculation
      not_advancing = new_performance.appearances.select { |a| !a.may_advance_to_next_round? }
      new_performance.appearances.delete(not_advancing)

      new_performance.warmup_time = new_performance.stage_time = nil # Clear scheduled times
      new_performance.warmup_venue_id = new_performance.stage_venue_id = nil # Clear assigned venues
      new_performance.appearances.each { |appearance| appearance.points = nil } # Clear points
      new_performance.predecessor = performance # Link to predecessor
      new_performances << new_performance # Add to list of performances that will be migrated
    end

    # Perform migration
    if target_competition && target_competition.performances << new_performances
      flash[:success] = "#{new_performances.size} \
                         #{Performance.model_name.human(count: new_performances.size)} \
                         wurde(n) erfolgreich nach #{target_competition.name} migriert."
      redirect_to jmd_competition_path(target_competition)
    else
      flash[:error] = "Es konnten nicht alle Vorspiele migriert werden."
      render 'list_advancing'
    end
  end

  # Send an info email to all participants who advanced to this competition
  def welcome_advanced
    # @competition is fetched by CanCan

    # Proceed if competition level is such that one can actually advance there
    if @competition.can_be_advanced_to?
      welcome_mail_count = 0

      @competition.performances.includes(:participants).each do |performance|
        performance.participants.each do |participant|
          # Send mail to participant asynchronously
          ParticipantMailer.delay.welcome_advanced(participant, performance)
          welcome_mail_count += 1
        end
      end

      flash[:success] = "#{welcome_mail_count} \
                         #{Participant.model_name.human(count: welcome_mail_count)} \
                         wurde(n) erfolgreich benachrichtigt."
    else
      flash[:error] = "Zu diesem Wettbewerb gibt es keine Weiterleitungen."
    end
    redirect_to jmd_competition_path(@competition)
  end

  private

    def load_migration_resources
      @possible_target_competitions = @competition.possible_successors.accessible_by(current_ability)

      # Get advancing performances
      @performances = @competition.performances.includes(:appearances, :pieces)
                                  .browsing_order
                                  .select { |p| p.advances_to_next_round? }
      # Split up based on whether the performance already has a successor
      @performances, @already_migrated = @performances.partition { |p| p.successor == nil }
    end
end
