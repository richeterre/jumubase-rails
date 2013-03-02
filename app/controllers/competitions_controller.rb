# -*- encoding : utf-8 -*-
class CompetitionsController < ApplicationController

  before_filter :get_performances_for_current_lw

  def classical_schedule
    @performances = @performances.classical
  end

  def popular_schedule
    @performances = @performances.popular
  end

  private

    def get_performances_for_current_lw
      lw_competition = Competition.seasonal_with_level(2).first
      @performances = lw_competition.performances
                                    .where("performances.stage_time IS NOT NULL")
                                    .includes(:category, :competition, :predecessor)
                                    .stage_order
    end
end
