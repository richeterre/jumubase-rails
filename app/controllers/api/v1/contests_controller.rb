module Api::V1
  class ContestsController < Api::ApiController
    def index
      contests = Contest
        .includes({ contest_categories: [:category, :performances] }, :host)
        .order("begins DESC")

      if params[:current_only] == "1"
        contests = contests.current
      end

      if timetable_filter = params[:timetables_public]
        filter_value = timetable_filter == "1" ? true : false
        contests = contests.with_timetables_public(filter_value)
      end

      @contests = contests
    end
  end
end
