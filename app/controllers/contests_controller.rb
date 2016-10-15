# -*- encoding : utf-8 -*-
class ContestsController < ApplicationController

  layout :desired_layout

  def signup
    @contests = Contest.current_and_open
  end

  def performances
    @contest = Contest.find(params[:id])
    @venue = Venue.find(params[:venue_id])
    @date = Date.parse(params[:date]) rescue nil

    if !@contest.timetables_public || !@contest.days.include?(@date)
      render 'pages/not_found'
    else
      @performances = @contest.staged_performances(@venue, @date)
        .includes({ contest_category: :category }, :predecessor, { appearances: :participant })
    end
  end

  private

    def desired_layout
       (params[:bare] == "yes") ? "bare_timetable" : "application"
    end
end
