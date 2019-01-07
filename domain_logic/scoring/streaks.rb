module Scoring
  class Streaks
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

      if this_game
        if event[:hits].include?(event[:guess])
          this_game[:streak] += 1

          if this_game[:streak] > 3
            streak_score = STREAK_SCORE[:higher_than_3]
          else
            streak_score = STREAK_SCORE[this_game[:streak]]
          end

          this_game[:score] += streak_score

          # Update just with the streak score
          # TheLeaderboard.update_leaderboard accumlates the score for each player
          # ... so, no real need to accumulate score in Streak score
         Leaderboard.update_leaderboard(
            player: event[:player],
            score: streak_score
          )
        else
          this_game[:streak] = 0
        end
      else
        games_and_score_data[game_id] = {
          score: 0,
          streak: 0
        }
      end

    end
  end
end