# -*- encoding : utf-8 -*-
class Jmd::PerformancesController < Jmd::BaseController
  include PerformancesHelper

  filterable_actions = [:index, :list_current, :make_certificates, :make_jury_sheets]

  # Actions that are routed as nested under Competition
  nested_actions = [:index, :make_certificates, :make_jury_sheets, :make_result_sheets]

  load_and_authorize_resource :competition, only: nested_actions
  load_and_authorize_resource :performance, except: nested_actions
  load_and_authorize_resource :performance, through: :competition, only: nested_actions

  skip_load_resource :performance, only: filterable_actions # for custom loading

  # Set up filters
  has_scope :in_competition, only: filterable_actions
  has_scope :advanced_from_competition, only: filterable_actions
  has_scope :in_category, only: filterable_actions
  has_scope :in_age_group, only: filterable_actions
  has_scope :on_date, only: filterable_actions
  has_scope :in_genre, only: filterable_actions

  # List current performances the user has access to
  def list_current
    @performances = apply_scopes(Performance).current
                                             .accessible_by(current_ability, :list_current)
                                             .order("created_at DESC")
                                             .paginate(page: params[:page], per_page: 15)
  end

  # show: @performance is fetched by CanCan

  def new
    # @performance is built by CanCan

    # Populate competition selector
    @competitions = Competition.accessible_by(current_ability)

    # Build initial resources for form
    1.times do
      appearance = @performance.appearances.build
      appearance.build_participant
    end
    1.times do
      piece = @performance.pieces.build
      piece.build_composer
    end
  end

  def create
    # @performance is built and populated from attributes by CanCan

    if @performance.save
      flash[:success] = "Das Vorspiel wurde erstellt."
      redirect_to jmd_performance_path(@performance)
    else
      # Here, too, set available competitions to choose from
      @competitions = Competition.accessible_by(current_ability)

      render 'new'
    end
  end

  def edit
    # @performance is fetched by CanCan

    # Populate competition selector
    @competitions = Competition.accessible_by(current_ability)
  end

  def update
    # @performance is fetched by CanCan

    if @performance.update_attributes(params[:performance])
      flash[:success] = "Das Vorspiel wurde erfolgreich geändert."
      redirect_to jmd_performance_path(@performance)
    else
      # Here, too, set available competitions to choose from
      @competitions = Competition.accessible_by(current_ability)

      render 'edit'
    end
  end

  def destroy
    # @performance is fetched by CanCan
    @performance.destroy
    flash[:success] = "Das Vorspiel wurde gelöscht."
    redirect_to jmd_competition_performances_path(@performance.competition)
  end

  def retime
    # @performance is fetched by CanCan

    # Switch to competition host's timeframe
    Time.zone = @performance.competition.host.time_zone

    date = params[:date]
    if (date == 'unscheduled')
      # Handle date removal
      time = nil
      @new_day = nil
    else
      offset = params[:offset]
      # Calculate time based on 9 o'clock start in host's time zone
      date_array = date.split('-').map(&:to_i)
      time = Time.zone.local(*date_array, 9) + offset.to_i.seconds
      # Pass new date to view for update
      @new_day = Date.strptime(date)
    end

    # Store old date for view update
    @old_day = (@performance.stage_time) ? @performance.stage_time.to_date : nil

    # Pass all performances for current view
    @performances = (@performance.category.popular?) ?
                     @performance.competition.performances.popular.browsing_order
                     : @performance.competition.performances.classical.browsing_order

    # Update entry time and date
    @performance.stage_time = time
    @performance.save_without_timestamping # Consider retiming an admin operation

    # Respond only to Ajax requests
    respond_to do |format|
      format.js
    end
  end

  ####
  # The following actions are nested under competitions/{id}

  # List performances in the given competition
  def index
    @performances = apply_scopes(Performance).where(competition_id: @competition)
                                             .accessible_by(current_ability)
                                             .order(:stage_time)
                                             .paginate(page: params[:page], per_page: 15)
  end

  # List performances for certificate printing
  def make_certificates
    # @competition is fetched by CanCan

    # Define params for PDF output
    prawnto filename: "urkunden#{random_number}", prawn: { page_size: 'A4', skip_page_creation: true }
    @performances = apply_scopes(Performance).where(competition_id: @competition)
                                             .accessible_by(current_ability)
                                             .order(:stage_time)
                                             .paginate(page: params[:page], per_page: 15)
  end

  # List performances for jury sheet printing
  def make_jury_sheets
    # @competition is fetched by CanCan

    # Define params for PDF output
    prawnto filename: "juryboegen#{random_number}", prawn: { page_size: 'A4', skip_page_creation: true }
    @performances = apply_scopes(Performance).where(competition_id: @competition)
                                             .accessible_by(current_ability)
                                             .order(:stage_time)
                                             .paginate(page: params[:page], per_page: 15)
  end

  # List performances for result sheet printing
  def make_result_sheets
    # @competition is fetched by CanCan

    # Define params for PDF output
    prawnto filename: "ergebnisliste#{random_number}", prawn: { page_size: 'A4', skip_page_creation: true }
    @category = Category.find(params[:category_id]) if params[:category_id]
    @age_group = params[:age_group] if params[:age_group]
    @performances = @competition.performances
                                .where(category_id: @category, age_group: @age_group)
                                .accessible_by(current_ability)
                                .order(:stage_time)
  end
end
