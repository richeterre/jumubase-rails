# -*- encoding : utf-8 -*-
class CompetitionsController < ApplicationController

  layout :desired_layout

  def lw_schedule
    venue_id = params[:venue]
    @venue = Venue.find(venue_id)

    date_array = params.slice(:year, :month, :day).values.map(&:to_i)

    if Date.valid_date?(*date_array)
      @date = Date.new(*date_array)
    else
      render 'pages/not_found'
    end

    @competition = Competition.seasonal_with_level(2).first
    @performances = @competition.performances
                                .where("performances.stage_time IS NOT NULL")
                                .includes(:category, :competition, :predecessor)
                                .stage_order
                                .on_date(@date)
                                .at_stage_venue(venue_id)
  end

  private

    def desired_layout
       (params[:bare] == "yes") ? "bare_timetable" : "application"
    end
end
