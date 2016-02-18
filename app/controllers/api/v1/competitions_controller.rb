module Api::V1
  class CompetitionsController < Api::ApiController
    def index
      @competitions = Competition.current
    end
  end
end
