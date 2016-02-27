module Api::V1
  class PerformancesController < Api::ApiController
    def index
      competition = Competition.find(params[:competition_id])
      @venue = Venue.find(params[:venue_id])

      # Parse given date assuming competition's local time zone
      local_tz = competition.host.time_zone
      @date = local_tz.parse(params[:date])

      @performances = competition.staged_performances(@venue, @date)
        .includes(
          { appearances: [:instrument, :participant, :role] },
          { pieces: :epoch },
          :category,
          competition: { host: :country },
          predecessor: { competition: { host: :country } }
        )
    end
  end
end
