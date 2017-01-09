module Api::V1
  class PerformancesController < Api::ApiController
    def index
      contest = Contest.find(params[:contest_id])
      if !contest.timetables_public
        return render nothing: true, status: :not_found
      end

      venue = Venue.find(params[:venue_id]) rescue nil

      # Parse given date assuming contest's local time zone
      local_tz = contest.host.time_zone
      date = local_tz.parse(params[:date]) rescue nil

      contest_category = ContestCategory.find(params[:contest_category_id]) rescue nil

      # TODO: Figure out param combinations that should lead to:
      #
      # return render nothing: true, status: :not_found

      if venue && date
        @performances = contest.staged_performances(venue, date)
      else
        @performances = contest.performances
      end

      if contest_category
        @performances = @performances.in_contest_category(contest_category)
      end

      @performances = @performances.includes(
        { appearances: [:instrument, :participant] },
        :pieces,
        contest_category: { contest: :host },
        predecessor: { contest_category: { contest: :host } }
      )
    end
  end
end
