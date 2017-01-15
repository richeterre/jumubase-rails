module Api::V1
  class PerformancesController < Api::ApiController
    def index
      contest = Contest.find(params[:contest_id])
      if !contest.timetables_public
        return render nothing: true, status: :not_found
      end

      @venue = Venue.find(params[:venue_id])

      # Parse given date assuming contest's local time zone
      local_tz = contest.host.time_zone
      @date = local_tz.parse(params[:date])

      @performances = contest.staged_performances(@venue, @date)
        .includes(
          { appearances: [:instrument, :participant] },
          :pieces,
          { contest_category: { contest: :host } },
          :predecessor # TODO: Find out why including associations here leads to wrong host data in response
        )
    end
  end
end
