module Api::V1
  class CompetitionsController < Api::ApiController
    def index
      if params[:current] == "1"
        @competitions = Competition.current.order("begins DESC")
      else
        @competitions = Competition.order("begins DESC")
      end
    end
  end
end
