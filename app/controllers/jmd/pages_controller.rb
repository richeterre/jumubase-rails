# -*- encoding : utf-8 -*-
class Jmd::PagesController < Jmd::BaseController

  def welcome
    authorize! :read, :welcome
  end

  def statistics
    authorize! :read, :statistics

    seasons = Contest.select(:season).map(&:season).uniq.sort

    @season_stats = seasons.map do |season|
      rw_contests = Contest.where(season: season, round: 1)
      rw_performances = Performance.in_contest(rw_contests)

      lw_contests = Contest.where(season: season, round: 2)
      lw_performances = Performance.in_contest(lw_contests)

      rw_stats = {
        classical: rw_performances.classical.count,
        kimu: rw_performances.kimu.count,
        popular: rw_performances.popular.count
      }
      rw_stats[:sum] = rw_stats[:classical] + rw_stats[:kimu] + rw_stats[:popular]

      lw_stats = {
        classical: lw_performances.classical.count,
        popular: lw_performances.popular.count
      }
      lw_stats[:sum] = lw_stats[:classical] + lw_stats[:popular]

      {
        season: season,
        rw_stats: rw_stats,
        lw_stats: lw_stats
      }
    end
  end
end
