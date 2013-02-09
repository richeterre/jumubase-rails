# -*- encoding : utf-8 -*-
class Jmd::PerformancesController < Jmd::BaseController
  include PerformancesHelper

  filterable_actions = [:index, :current, :make_certificates, :make_jury_sheets]

  load_and_authorize_resource # CanCan
  skip_load_resource only: filterable_actions # for custom loading

  # Set up filters
  has_scope :in_competition, only: filterable_actions
  has_scope :advanced_from_competition, only: filterable_actions
  has_scope :in_category, only: filterable_actions
  has_scope :in_age_group, only: filterable_actions

  # List performances in the given competition
  def index
    @competition = Competition.find(params[:competition_id])
    @performances = apply_scopes(Performance).where(competition_id: @competition)
                                             .accessible_by(current_ability)
                                             .order("created_at DESC")
                                             .paginate(page: params[:page], per_page: 15)
  end

  # List current performances the user has access to
  def current
    @performances = apply_scopes(Performance).current
                                             .accessible_by(current_ability)
                                             .order("created_at DESC")
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

  ####
  # The following actions are nested under competitions/{id}

  def make_certificates
    @competition = Competition.find(params[:competition_id])

    # Define params for PDF output
    prawnto filename: "urkunden#{random_number}", prawn: { page_size: 'A4', skip_page_creation: true }
    @performances = apply_scopes(Performance).where(competition_id: @competition)
                                             .accessible_by(current_ability)
                                             .browsing_order
                                             .paginate(page: params[:page], per_page: 15)
  end

  def make_jury_sheets
    @competition = Competition.find(params[:competition_id])

    # Define params for PDF output
    prawnto filename: "juryboegen#{random_number}", prawn: { page_size: 'A4', skip_page_creation: true }
    @performances = apply_scopes(Performance).where(competition_id: @competition)
                                             .accessible_by(current_ability)
                                             .browsing_order
                                             .paginate(page: params[:page], per_page: 15)
  end
end
