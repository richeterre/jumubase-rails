# -*- encoding : utf-8 -*-
class ContestsController < ApplicationController

  layout :desired_layout

  def signup
    @contests = Contest.current.open
  end

  def performances
    @contest = Contest.find(params[:id])
    @venue = Venue.find(params[:venue_id]) rescue nil
    @date = Date.parse(params[:date]) rescue nil

    if !@contest.timetables_public || !@contest.days.include?(@date) || !@venue
      render 'pages/not_found'
    else
      @performances = @contest.staged_performances_at_venue_on_date(@venue, @date)
        .includes({ contest_category: :category }, :predecessor, { appearances: :participant })
    end
  end

  private

    def desired_layout
       (params[:bare] == "yes") ? "bare_timetable" : "application"
    end
end
