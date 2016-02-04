module Api::V1
  class CompetitionsController < ApiController
    def index
      @competitions = Competition.current
    end
  end
end
