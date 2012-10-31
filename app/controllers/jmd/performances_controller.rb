# -*- encoding : utf-8 -*-
class Jmd::PerformancesController < Jmd::BaseController
  # if JUMU_ROUND > 1
  #   # Non-admins can own entries only in 1st round
  #   before_filter :require_admin, :except => :browse
  # end

  # helper_method :sort_order

  # # Define scopes for entry filtering
  # has_scope :is_popular, :only => [:index, :make_certificates, :make_jury_sheets]
  # has_scope :in_category, :only => [:index, :make_certificates, :make_jury_sheets]
  # has_scope :from_host, :only => [:index, :make_certificates, :make_jury_sheets]
  # has_scope :on_date, :only => [:index, :make_certificates, :make_jury_sheets]

  # Manage entries at hosts the user has access to
  def index
    # filter_sort_entries
    @performances = Performance.current.visible_to(current_user)
  end

  # def browse
  #   @title = "Angemeldete Wertungen"
  #   @entries = Entry.current
  #                   .visible_to(current_user)
  #                   .joins(:category)
  #                   .category_order
  #                   .paginate(:page => params[:page], :per_page => 10)
  # end

  # def show
  #   @title = "Wertungsdetails"
  #   @entry = Entry.current.visible_to(current_user).find(params[:id])
  # end

  def edit
    @performance = Performance.current.visible_to(current_user).find(params[:id])
  end

  def update
    @performance = Performance.current.visible_to(current_user).find(params[:id])
    # Make all attributes accessible to admins
    @performance.accessible = :all if admin?
    if @performance.update_attributes(params[:performance])
      flash[:success] = "Die Anmeldung wurde erfolgreich aktualisiert."
      redirect_to jmd_performances_path
    else
      render 'edit'
    end
  end

  def destroy
    @performance = Performance.current.visible_to(current_user).find(params[:id]).destroy
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

  # def make_certificates
  #   # Define params for PDF output
  #   prawnto :prawn => { :page_size => 'A4', :skip_page_creation => true }
  #   @title = "Urkunden erstellen"
  #   filter_sort_entries
  # end

  # def make_jury_sheets
  #   # Define params for PDF output
  #   prawnto :prawn => { :page_size => 'A4', :skip_page_creation => true }
  #   @title = "Jurybögen erstellen"
  #   filter_sort_entries
  # end

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