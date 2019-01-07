require 'csv'

module Scoring
  class Complexity
    attr_accessor :complexity_score

    def initialize
      @complexity_score = nil
    end

    COMPLEXITY_SCORE = {
      3 => 10,
      4 => 20,
      5 => 30,
      higher_than_5: 100
    }

    def call(event)
      return if @complexity_score

      random_word_length = event[:random_word].length
      if random_word_length >= 5
        @complexity_score = COMPLEXITY_SCORE[:higher_than_5]
      elsif random_word_length < 3
        puts "No Complexity score for words less than 3"
      else
        @complexity_score = COMPLEXITY_SCORE[random_word_length]
      end

     Leaderboard.update_leaderboard(
        player: event[:player],
        score: @complexity_score
      )
    end

  end
end