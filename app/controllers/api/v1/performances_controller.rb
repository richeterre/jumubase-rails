module Api::V1
  class PerformancesController < Api::ApiController
    def index
      contest = Contest.find(params[:contest_id])
      if !contest.timetables_public
        return render nothing: true, status: :not_found
      end

      ## Getting parameters

      venue = Venue.find(params[:venue_id]) rescue nil

      local_tz = contest.host.time_zone # Assume contest's local time zone
      date = local_tz.parse(params[:date]) rescue nil

      contest_category = ContestCategory.find(params[:contest_category_id]) rescue nil

      if results_public_filter = params[:results_public]
        # Active filter has 'true' or 'false' value, 'nil' means inactive
        results_public_value = results_public_filter == "1" ? true : false
      end

      ## Validation

      # Require both venue and date if either is present
      if !venue && date || venue && !date
        return render nothing: true, status: :bad_request
      end

      ## Filtering

      # Filter by venue and date
      if venue && date
        @performances = contest.staged_performances_at_venue_on_date(venue, date)
      else
        @performances = contest.staged_performances
      end

      # Filter by contest category
      if contest_category
        @performances = @performances.in_contest_category(contest_category)
      end

      # Filter by result publicity
      if !results_public_value.nil?
        @performances = @performances.where(results_public: results_public_value)
      end

      ## Fetching associations

      @performances = @performances.includes(
        { appearances: [:instrument, :participant] },
        :pieces,
        contest_category: [:category, { contest: :host }],
        predecessor: { contest_category: { contest: :host } }
      )
    end
  end
end
