# -*- encoding : utf-8 -*-
class Jmd::VenuesController < Jmd::BaseController

  load_and_authorize_resource :contest
  load_and_authorize_resource :venue

  def schedule
    # @contest is fetched by CanCan
    # @venue is fetched by CanCan
    @categories = Category.current
    @performances = @contest.performances
                                .includes(:predecessor, :participants)
                                .venueless_or_at_stage_venue(@venue.id)
                                .browsing_order
  end
end
