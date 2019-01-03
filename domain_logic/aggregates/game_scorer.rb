module Aggregate
  class GameScorer
    attr_accessor :games_and_score_data

    def initialize
      @games_and_score_data = {}
    end

    STREAK_SCORE = {
      1 => 10,
      2 => 100,
      3 => 1000,
      higher_than_3: 5000
    }

    def call(event)
      # Find the Scoring Data for only this Game
      game_id = event[:game_id]
      return unless game_id

      this_game = games_and_score_data[game_id]

      # Handle the Points for Streaks logic
      # (Time based points next)
      if this_game
        if event[:hits].include?(event[:guess])
          this_game[:streak] += 1

          if this_game[:streak] > 3
            this_game[:score] += STREAK_SCORE[:higher_than_3]
          else
            this_game[:score] += STREAK_SCORE[this_game[:streak]]
          end

        else
          this_game[:streak] = 0
        end
      else
        games_and_score_data[game_id] = {
          score: 0,
          streak: 0
        }
      end

      puts "Inside GameScorer"
      p self
    end


  end
end