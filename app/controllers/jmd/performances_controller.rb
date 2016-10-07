# -*- encoding : utf-8 -*-
class Jmd::PerformancesController < Jmd::BaseController
  include ApplicationHelper

  filterable_actions = [:index, :list_current, :make_certificates, :make_jury_sheets]

  # Actions that are routed as nested under Contest
  nested_actions = [:index, :make_certificates, :make_jury_sheets, :make_result_sheets]

  load_and_authorize_resource :contest, only: nested_actions
  load_and_authorize_resource :performance, except: nested_actions
  load_and_authorize_resource :performance, through: :contest, only: nested_actions

  skip_load_resource :performance, only: filterable_actions # for custom loading

  # Set up filters
  has_scope :in_contest, only: filterable_actions
  has_scope :advanced_from_contest, only: filterable_actions
  has_scope :in_category, only: filterable_actions
  has_scope :in_age_group, only: filterable_actions
  has_scope :on_date, only: filterable_actions
  has_scope :at_stage_venue, only: filterable_actions
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

    # Populate contest selector
    @contests = Contest.accessible_by(current_ability).order("begins DESC")

    # Build initial resources for form
    1.times do
      appearance = @performance.appearances.build
      appearance.build_participant
    end
    @performance.pieces.build
  end

  def create
    # @performance is built and populated from attributes by CanCan

    if @performance.save
      flash[:success] = "Das Vorspiel wurde erstellt."
      redirect_to jmd_performance_path(@performance)
    else
      # Here, too, set available contests to choose from
      @contests = Contest.accessible_by(current_ability)

      render 'new'
    end
  end

  def edit
    # @performance is fetched by CanCan

    # Populate contest selector
    @contests = Contest.accessible_by(current_ability)
  end

  def update
    # @performance is fetched by CanCan

    if @performance.update_attributes(params[:performance])
      flash[:success] = "Das Vorspiel wurde erfolgreich geändert."
      redirect_to jmd_performance_path(@performance)
    else
      # Here, too, set available contests to choose from
      @contests = Contest.accessible_by(current_ability)

      render 'edit'
    end
  end

  def destroy
    # @performance is fetched by CanCan
    @performance.destroy
    flash[:success] = "Das Vorspiel wurde gelöscht."
    redirect_to jmd_contest_performances_path(@performance.contest)
  end

  def reschedule
    # @performance is fetched by CanCan

    # Switch to contest host's timeframe
    Time.zone = @performance.contest.host.time_zone

    date = params[:date]
    stage_venue_id = params[:stage_venue_id]

    if (date == 'unscheduled')
      # Handle date and venue removal
      time = nil
      @new_day = nil
      @new_stage_venue = nil
    else
      offset = params[:offset]
      # Calculate time based on 9 o'clock start in host's time zone
      date_array = date.split('-').map(&:to_i)
      time = Time.zone.local(*date_array, 9) + offset.to_i.seconds
      # Pass new date to view for update
      @new_day = Date.strptime(date)
      @new_stage_venue = Venue.find(stage_venue_id)
    end

    # Store old date and venue for view update
    @old_day = (@performance.stage_time) ? @performance.stage_time.to_date : nil
    @old_stage_venue = @performance.stage_venue

    # Pass all performances for current view
    @performances = @performance.contest.performances.browsing_order

    # Update entry time, date and venue
    @performance.stage_time = time
    @performance.stage_venue = @new_stage_venue
    @performance.save_without_timestamping # Consider rescheduling an admin operation

    # Respond only to Ajax requests
    respond_to do |format|
      format.js
    end
  end

  ####
  # The following actions are nested under contests/{id}

  # List performances in the given contest
  def index
    @performances = apply_scopes(Performance).where(contest_id: @contest)
                                             .accessible_by(current_ability)
                                             .order(:stage_time)
                                             .paginate(page: params[:page], per_page: 15)
  end

  # List performances for certificate printing
  def make_certificates
    # @contest is fetched by CanCan

    # Define params for PDF output
    prawnto filename: "urkunden#{random_number}", prawn: { page_size: 'A4', skip_page_creation: true }
    @performances = apply_scopes(Performance).where(contest_id: @contest)
                                             .accessible_by(current_ability)
                                             .order(:stage_time)
                                             .paginate(page: params[:page], per_page: 15)
  end

  # List performances for jury sheet printing
  def make_jury_sheets
    # @contest is fetched by CanCan

    # Define params for PDF output
    prawnto filename: "juryboegen#{random_number}", prawn: { page_size: 'A4', skip_page_creation: true }
    @performances = apply_scopes(Performance).where(contest_id: @contest)
                                             .accessible_by(current_ability)
                                             .order(:stage_time)
                                             .paginate(page: params[:page], per_page: 15)
  end

  # List performances for result sheet printing
  def make_result_sheets
    # @contest is fetched by CanCan

    # Define params for PDF output
    prawnto filename: "ergebnisliste#{random_number}", prawn: { page_size: 'A4', skip_page_creation: true }
    @category = Category.find(params[:category_id]) if params[:category_id]
    @age_group = params[:age_group] if params[:age_group]
    @performances = @contest.performances
                                .where(category_id: @category, age_group: @age_group)
                                .accessible_by(current_ability)
                                .order(:stage_time)
  end
end
