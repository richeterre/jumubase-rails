module Api::V1
  class CompetitionsController < Api::ApiController
    def index
      competitions = Competition.order("begins DESC")

      if params[:current_only] == "1"
        competitions = competitions.current
      end

      if timetable_filter = params[:timetables_public]
        filter_value = timetable_filter == "1" ? true : false
        competitions = competitions.with_timetables_public(filter_value)
      end

      @competitions = competitions
    end
  end
end
