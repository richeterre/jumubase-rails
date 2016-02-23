# -*- encoding : utf-8 -*-
class CompetitionsController < ApplicationController

  layout :desired_layout

  def performances
    @competition = Competition.find(params[:id])
    @venue = Venue.find(params[:venue_id])
    @date = Date.parse(params[:date]) rescue nil

    if !@competition.timetables_public || !@competition.days.include?(@date)
      render 'pages/not_found'
    else
      @performances = @competition.staged_performances(@venue, @date)
        .includes(:category, :competition, :predecessor)
    end
  end

  private

    def desired_layout
       (params[:bare] == "yes") ? "bare_timetable" : "application"
    end
end
