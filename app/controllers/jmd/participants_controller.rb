# -*- encoding : utf-8 -*-
class Jmd::ParticipantsController < Jmd::BaseController

  load_and_authorize_resource :competition
  load_and_authorize_resource :participant, through: :competition

  def index
    # @competition and @participants are fetched by CanCan
    # TODO: Why doesn't authorization work although competition can be accessed by user?
    @participants = @participants.includes(:country).order(:last_name)
  end

  def show
    # @participant is fetched by CanCan
  end
end
