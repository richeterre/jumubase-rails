# -*- encoding : utf-8 -*-
class PerformancesController < ApplicationController

  # Presents the signup form for participants
  def new
    @performance = Performance.new

    # Set contests that the person can sign up for
    @contests = Contest.current_and_open

    # Build initial resources for form
    1.times do
      appearance = @performance.appearances.build
      appearance.build_participant
    end
    1.times do
      @performance.pieces.build
    end
  end

  # Creates a new performance upon signup form submission
  def create
    # Create empty performance
    @performance = Performance.new
    # Make all attributes accessible to admins
    # @performance.accessible = :all if admin?
    @performance.attributes = params[:performance]

    if @performance.save
      # Send out confirmation emails with edit code
      @performance.participants.each do |participant|
        ParticipantMailer.delay.signup_confirmation(participant, @performance)
      end

      flash[:success] = "Die Anmeldung wurde erfolgreich gespeichert."
      redirect_to root_path
    else
      # Here, too, set contests that the person can sign up for
      @contests = Contest.current_and_open

      render 'new'
    end
  end

  # Finds an existing signup form by edit code and redirects to it
  def search
    unless params[:tracing_code].nil? # needed to show empty form
      if params[:tracing_code].empty?
        flash.now[:error] = "Bitte gib den Änderungscode für die gesuchte Anmeldung an."
      else
        existing = Performance.find_by_tracing_code(params[:tracing_code])
        if existing.nil?
          flash.now[:error] = "Keine Anmeldung unter diesem Änderungscode gefunden."
        elsif existing.contest.signup_deadline <= Time.now
          flash.now[:error] = t('messages.deadline_passed',
                                deadline: l(existing.contest.last_signup_date, format: :long))
        else
          redirect_to edit_performance_path(existing, tracing_code: params[:tracing_code])
        end
      end
    end
  end

  # Presents an existing signup form for editing
  def edit
    @performance = Performance.in_open_contest.find(params[:id])

    unless @performance[:tracing_code] == params[:tracing_code]
      flash[:error] = "Bitte gib einen gültigen Änderungscode ein."
      redirect_to signup_search_path
    end
  end

  # Stores changes made to an existing signup form
  def update
    @performance = Performance.in_open_contest.find(params[:id])
    if @performance.update_attributes(params[:performance])
      flash[:success] = "Die Anmeldung wurde erfolgreich aktualisiert."
      redirect_to signup_search_path
      # redirect_to performances_path
    else
      # Here, too, set contests that the person can sign up for
      @contests = Contest.current_and_open

      render 'edit'
    end
  end
end
