# -*- encoding : utf-8 -*-
class Jmd::PagesController < Jmd::BaseController

  def statistics
    authorize! :read, :statistics

    seasons = Contest.select(:season).map(&:season).uniq.sort

    @season_stats = seasons.map do |season|
      round_1_performances = Performance.in_contest(
        Contest.where(season: season, round: 1)
      )
      # TODO: Replace this by own "kimu" genre
      kimu = Category.find_by_name('"Kinder musizieren"')

      round_1_kimu = round_1_performances.in_category(kimu).count
      round_1_classical = round_1_performances.classical.count - round_1_kimu
      round_1_popular = round_1_performances.popular.count

      round_2_performances = Performance.in_contest(
        Contest.where(season: season, round: 2)
      )
      round_2_classical = round_2_performances.classical.count
      round_2_popular = round_2_performances.popular.count

      {
        season: season,
        round_1_sum: round_1_kimu + round_1_classical + round_1_popular,
        round_1_kimu: round_1_kimu,
        round_1_classical: round_1_classical,
        round_1_popular: round_1_popular,
        round_2_sum: round_2_classical + round_2_popular,
        round_2_classical: round_2_classical,
        round_2_popular: round_2_popular,
      }
    end
  end
end
