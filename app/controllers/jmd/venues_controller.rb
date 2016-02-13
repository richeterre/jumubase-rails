# -*- encoding : utf-8 -*-
class Jmd::VenuesController < Jmd::BaseController

  layout :desired_layout

  load_and_authorize_resource :competition
  load_and_authorize_resource :venue

  def schedule
    # @competition is fetched by CanCan
    # @venue is fetched by CanCan
    @categories = Category.current
    @performances = @competition.performances
                                .includes(:predecessor, :participants)
                                .venueless_or_at_stage_venue(@venue.id)
                                .browsing_order
  end

  def show_timetable
    # @competition is fetched by CanCan
    # @venue is fetched by CanCan

    date_array = params.slice(:year, :month, :day).values.map(&:to_i)

    if Date.valid_date?(*date_array)
      @date = Date.new(*date_array)
    else
      render 'pages/not_found'
    end

    @performances = @competition.staged_performances(@venue, @date)
                                .includes(:category, :competition)
  end

  private

    def desired_layout
       (params[:bare] == "yes") ? "bare_timetable" : "application"
    end
end
