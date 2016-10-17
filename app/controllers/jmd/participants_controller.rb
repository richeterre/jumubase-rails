# -*- encoding : utf-8 -*-
class Jmd::ParticipantsController < Jmd::BaseController
  include ApplicationHelper

  load_and_authorize_resource :contest
  load_and_authorize_resource :participant, through: :contest

  def index
    # @contest and @participants are fetched by CanCan
    # TODO: Why doesn't authorization work although contest can be accessed by user?
    @participants = @participants.order(:last_name)

    respond_to do |format|
       format.csv { render csv: @participants, filename: "teilnehmer#{random_number}" }
       format.html
    end
  end

  def show
    # @participant is fetched by CanCan
  end
end
