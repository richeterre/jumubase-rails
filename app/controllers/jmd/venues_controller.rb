# -*- encoding : utf-8 -*-
class Jmd::VenuesController < Jmd::BaseController

  load_and_authorize_resource :competition
  load_and_authorize_resource :venue

  def schedule
    # @competition is fetched by CanCan
    # @venue is fetched by CanCan
    @categories = Category.current
    @performances = @competition.performances
                                .includes(:predecessor, :participants)
                                .venueless_or_at_stage_venue(@venue)
                                .browsing_order
  end
end
