module Scoring
  class Speed
    attr_accessor :games_and_score_data

    def initialize
      @games_and_score_data = {}
    end

    # get the time between Events (game plays )
    # add some scoring

    def call(event)
      puts "TODO: Implement Scoring::Speed (time based scoring)"
      p self
    end

  end
end