# -*- encoding : utf-8 -*-
class Jmd::VenuesController < Jmd::BaseController

  load_and_authorize_resource :contest
  load_and_authorize_resource :venue

  def schedule
    # @contest is fetched by CanCan
    # @venue is fetched by CanCan
    @contest_categories = @contest.contest_categories.includes(:category)
    @performances = @contest.performances
      .includes(:predecessor, :participants, { contest_category: :category })
      .venueless_or_at_stage_venue(@venue.id)
      .browsing_order
  end
end
