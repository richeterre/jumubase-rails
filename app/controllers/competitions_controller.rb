# -*- encoding : utf-8 -*-
class CompetitionsController < ApplicationController

  layout :desired_layout

  def lw_schedule
    @venue = Venue.find(params[:venue])

    date_array = params.slice(:year, :month, :day).values.map(&:to_i)

    if Date.valid_date?(*date_array)
      @date = Date.new(*date_array)
    else
      render 'pages/not_found'
    end

    @competition = Competition.seasonal_with_level(2).first
    @performances = @competition.staged_performances(@venue, @date)
                                .includes(:category, :competition, :predecessor)
  end

  private

    def desired_layout
       (params[:bare] == "yes") ? "bare_timetable" : "application"
    end
end
