# -*- encoding : utf-8 -*-
class CompetitionsController < ApplicationController

  before_filter :get_performances_for_current_lw
  layout :set_layout

  def classical_schedule
    @performances = @performances.classical
  end

  def popular_schedule
    @performances = @performances.popular
  end

  private

    def get_performances_for_current_lw
      date_array = params.slice(:year, :month, :day).values.map(&:to_i)
      if Date.valid_date?(*date_array)
        @date = Date.new(*date_array)
      else
        render 'pages/not_found'
      end


      @lw_competition = Competition.seasonal_with_level(2).first
      @performances = @lw_competition.performances
                                     .where("performances.stage_time IS NOT NULL")
                                     .includes(:category, :competition, :predecessor)
                                     .stage_order
                                     .on_date(@date)
    end

    def set_layout
       (params[:bare] == "yes") ? "bare_timetable" : "application"
    end
end
