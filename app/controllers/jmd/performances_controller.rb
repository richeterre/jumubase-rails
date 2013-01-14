# -*- encoding : utf-8 -*-
class Jmd::PerformancesController < Jmd::BaseController
  include PerformancesHelper

  load_and_authorize_resource except: [:make_certificates, :make_jury_sheets]
  skip_authorization_check only: [:make_certificates, :make_jury_sheets]

  # helper_method :sort_order

  # Define scopes for entry filtering
  # has_scope :is_popular, only: :make_certificates
  has_scope :in_competition, only: [:make_certificates, :make_jury_sheets]
  has_scope :in_category, only: [:make_certificates, :make_jury_sheets]
  has_scope :in_age_group, only: [:make_certificates, :make_jury_sheets]
  # has_scope :from_host, :only => [:index, :make_certificates, :make_jury_sheets]
  # has_scope :on_date, :only => [:index, :make_certificates, :make_jury_sheets]

  # Manage entries at hosts the user has access to
  def index
    # filter_sort_entries
    # @performances are fetched by CanCan
    @performances = @performances.current.order("created_at DESC")
                                 .paginate(page: params[:page], per_page: 15)
  end

  # show: @performance is fetched by CanCan

  def new
    # @performance is built by CanCan

    # Populate competition selector
    @competitions = Competition.accessible_by(current_ability).current

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

  # Creates a new performance upon signup form submission
  def create
    # @performance is built by CanCan

    @performance.attributes = params[:performance]

    if @performance.save
      # Send out confirmation emails with edit code
      @performance.participants.each do |participant|
        ParticipantMailer.signup_confirmation(participant, @performance).deliver
      end

      flash[:success] = "Das Vorspiel wurde erstellt."
      redirect_to jmd_performances_path
    else
      # Here, too, set available competitions to choose from
      @competitions = Competition.accessible_by(current_ability).current

      render 'new'
    end
  end

  def edit
    # @performance is fetched by CanCan

    # Populate competition selector
    @competitions = Competition.accessible_by(current_ability).current
  end

  def update
    # @performance is fetched by CanCan

    if @performance.update_attributes(params[:performance])
      flash[:success] = "Das Vorspiel wurde erfolgreich geändert."
      redirect_to jmd_performances_path
    else
      # Here, too, set available competitions to choose from
      @competitions = Competition.accessible_by(current_ability).current

      render 'edit'
    end
  end

  def destroy
    # @performance is fetched by CanCan
    @performance.destroy
    flash[:success] = "Das Vorspiel wurde gelöscht."
    redirect_to jmd_performances_path
  end

  # def retime
  #   entry = Entry.current.visible_to(current_user).find(params[:entry_id])
  #   # Switch to competition host's timeframe
  #   Time.zone = entry.competition.host.time_zone

  #   date = params[:date]
  #   if (date == 'unscheduled')
  #     # Handle date removal
  #     time = nil
  #     @new_day = nil
  #   else
  #     offset = params[:offset]
  #     # Calculate time based on 9 o'clock start in host's time zone
  #     date_array = date.split('-').map(&:to_i)
  #     time = Time.zone.local(*date_array, 9) + offset.to_i.seconds
  #     # Pass new date to view for update
  #     @new_day = Date.strptime(date)
  #   end

  #   # Store old date for view update
  #   @old_day = (entry.stage_time) ? entry.stage_time.to_date : nil

  #   # Pass all entries for current view
  #   @entries = (entry.category.popular?) ?
  #                entry.competition.entries.popular.category_order
  #              : entry.competition.entries.classical.category_order

  #   # Update entry time and date
  #   entry.stage_time = time
  #   entry.save

  #   # Respond only to Ajax requests
  #   respond_to do |format|
  #     format.js
  #   end
  # end

  def make_certificates
    # Define params for PDF output
    prawnto filename: "urkunden#{random_number}", prawn: { page_size: 'A4', skip_page_creation: true }
    # filter_sort_entries
    @performances = apply_scopes(Performance).accessible_by(current_ability).current
                                             .browsing_order
                                             .paginate(page: params[:page], per_page: 15)
  end

  def make_jury_sheets
    # Define params for PDF output
    prawnto filename: "juryboegen#{random_number}", prawn: { page_size: 'A4', skip_page_creation: true }
    @performances = apply_scopes(Performance).accessible_by(current_ability).current
                                             .browsing_order
                                             .paginate(page: params[:page], per_page: 15)
  end

  # def make_result_sheets
  #   # Define params for PDF output
  #   prawnto :prawn => { :page_size => 'A4', :skip_page_creation => true }
  #   @pop_entries = Entry.current.popular.stage_order
  #   @classical_entries = Entry.current.classical.stage_order
  #   @title = "Ergebnislisten erstellen"
  # end

  # private

  #   def filter_sort_entries
  #     # Filter and column-sort entries
  #     @entries = apply_scopes(Entry)
  #                .current
  #                .visible_to(current_user)
  #                .joins(:category)
  #                .order(sort_order)
  #     # Provide competition for date filtering
  #     @competition = current_user.competitions.current.first
  #   end

  #   def sort_order
  #     if params[:sort].blank?
  #       "stage_time"
  #     else
  #       params[:sort] + ", stage_time"
  #     end
  #   end
end
