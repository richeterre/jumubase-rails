# -*- encoding : utf-8 -*-
class Jmd::ParticipantsController < Jmd::BaseController
  include ApplicationHelper

  load_and_authorize_resource :contest
  load_and_authorize_resource :participant, through: :contest

  def index
    # @contest and @participants are fetched by CanCan
    # TODO: Why doesn't authorization work although contest can be accessed by user?
    @participants = @participants.order(:last_name)

    performances = Performance
      .in_contest(@contest)
      .includes({ contest_category: :category }, :appearances)

    # Create hash of participants with their associated performances for listing
    @participant_performances = {}
    performances.each do |performance|
      performance.appearances.each do |appearance|
        performances = @participant_performances[appearance.participant_id] ||= []
        performances << performance
      end
    end

    respond_to do |format|
       format.csv { render csv: @participants, filename: "teilnehmer#{random_number}" }
       format.html
    end
  end

  def show
    # @participant is fetched by CanCan
  end
end
