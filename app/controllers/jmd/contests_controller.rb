# -*- encoding : utf-8 -*-
class Jmd::ContestsController < Jmd::BaseController

  layout :desired_layout

  load_and_authorize_resource # CanCan

  def index
    # @contests are fetched by CanCan
    @contests = @contests.includes(:host).order("begins DESC")
  end

  def new
    # @contest is built by CanCan
    @rounds = allowed_rounds
  end

  def create
    # @contest is built by CanCan
    if @contest.save
      flash[:success] = "Der Wettbewerb #{@contest.name} wurde erstellt."
      redirect_to jmd_contests_path
    else
      @rounds = allowed_rounds
      render 'new'
    end
  end

  # show: @contest is fetched by CanCan

  def edit
    # @contest is fetched by CanCan
    @rounds = allowed_rounds
  end

  def update
    # @contest is fetched by CanCan
    if @contest.update_attributes(params[:contest])
      flash[:success] = "Der Wettbewerb \"#{@contest.name}\" wurde erfolgreich geändert."
      redirect_to jmd_contests_path
    else
      @rounds = allowed_rounds
      render 'edit'
    end
  end

  def destroy
    # @contest is fetched by CanCan
    @contest.destroy
    flash[:success] = "Der Wettbewerb \"#{@contest.name}\" wurde gelöscht."
    redirect_to jmd_contests_path
  end

  # Show performance timetables
  def show_timetables
    # @contest is fetched by CanCan
    @venue = Venue.find(params[:venue_id])
    @date = Date.parse(params[:date]) rescue nil

    if !@contest.days.include?(@date)
      render 'pages/not_found'
    else
      @performances = @contest.staged_performances(@venue, @date)
        .includes(
          { appearances: [:instrument, :participant] },
          { contest_category: :contest },
          :pieces,
          :predecessor
        )
    end
  end

  # List performances that advance to the next round
  def list_advancing
    # @contest is fetched by CanCan
    load_migration_resources # Loads possible target contests, migratable performances and already migrated
  end

  # Migrate advancing performances to a selected contest
  def migrate_advancing
    # @contest is fetched by CanCan

    load_migration_resources # Loads possible target contests, migratable performances and already migrated
    target_contest = @possible_target_contests.find(params[:target_contest_id]) # Load selected target

    if target_contest.nil?
      flash[:error] = "Der Zielwettbewerb wurde nicht gefunden."
      render 'list_advancing'
    end

    # Collect performances for migration
    new_performances = []
    @performances.each do |performance|
      # Find corresponding contest category from target contest
      new_contest_category = target_contest.contest_categories
        .where(category_id: performance.contest_category.category_id)
        .first

      next if new_contest_category.nil?

      new_performance = performance.amoeba_dup # Deep duplicate

      # Remove appearances that don't advance
      # This is buggy when not deleting all at once, probably due to coupling during age group calculation
      not_advancing = new_performance.appearances.select { |a|
        !a.may_advance_to_next_round? && !a.accompaniment?
        # TODO: Currently non-qualified pop accompanist groups must be removed by hand after migration
      }
      new_performance.appearances.delete(not_advancing)

      # Assign to contest category in new contest
      new_performance.contest_category = new_contest_category

      # Clear attributes that become invalid after advancing
      new_performance.stage_time = nil
      new_performance.stage_venue = nil

      new_performance.appearances.each { |appearance| appearance.points = nil } # Clear points
      new_performance.predecessor = performance # Link to predecessor
      new_performances << new_performance # Add to list of performances that will be migrated
    end

    # Perform migration
    begin
      ActiveRecord::Base.transaction { new_performances.each(&:save!) }
      flash[:success] = "#{new_performances.size} \
                         #{Performance.model_name.human(count: new_performances.size)} \
                         wurde(n) erfolgreich nach #{target_contest.name} migriert."
      redirect_to jmd_contest_path(target_contest)
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Die Vorspiele konnten nicht migriert werden."
      render 'list_advancing'
    end
  end

  # Send an info email to all participants who advanced to this contest
  def welcome_advanced
    # @contest is fetched by CanCan

    # Proceed if contest level is such that one can actually advance there
    if @contest.can_be_advanced_to?
      welcome_mail_count = 0

      @contest.performances.includes(:participants).each do |performance|
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
    redirect_to jmd_contest_path(@contest)
  end

  private

    def load_migration_resources
      @possible_target_contests = @contest.possible_successors.accessible_by(current_ability)

      # Get advancing performances
      @performances = @contest.performances.includes(:appearances, :pieces)
                                  .browsing_order
                                  .select { |p| p.advances_to_next_round? }
      # Split up based on whether the performance already has a successor
      @performances, @already_migrated = @performances.partition { |p| p.successor == nil }
    end

    def desired_layout
       (params[:bare] == "yes") ? "bare_timetable" : "application"
    end

    def allowed_rounds
      [1, 2] # Only allow adding contests for these rounds
    end
end
