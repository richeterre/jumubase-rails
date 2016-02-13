module Api::V1
  class PerformancesController < ApiController
    def index
      competition = Competition.find(params[:competition_id])
      @venue = Venue.find(params[:venue_id])
      @date = Date.strptime(params[:date], '%Y-%m-%d')

      @performances = competition.staged_performances(@venue, @date)
        .includes(
          { appearances: [:instrument, :participant, :role] },
          :category,
          competition: { host: :country }
        )
    end

    def show
      @performance = Performance.find(params[:id])
        .includes(
          { appearances: [:instrument, :participant, :role] },
          { pieces: :epoch }
        )
    end
  end
end
