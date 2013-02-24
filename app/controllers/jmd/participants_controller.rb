# -*- encoding : utf-8 -*-
class Jmd::ParticipantsController < Jmd::BaseController

  load_and_authorize_resource :competition
  load_and_authorize_resource :participant, through: :competition

  def index
    # @competition and @participants are fetched by CanCan
    @participants = @participants.includes(:country)
  end

end
