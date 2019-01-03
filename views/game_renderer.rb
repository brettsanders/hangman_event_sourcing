require_relative '../assets/images.rb'

module Views
  class GameRenderer
    def call(event)

      puts IMAGES[event[:misses].length]
      puts "Your word: (#{event[:random_word].length} letters long)"
      puts event[:random_word].split('').map{|c| event[:hits].include?(c) ? c + " " : "_ "}.join()

      if won_game?(event)
        puts "Congratulations! You won the game"
      end

      if lost_game?(event)
        puts "Sorry, you lost"
      end

      if event[:guess] == "" or event[:guess].nil?
        puts "Game is beginning..."
        puts "You have made no guesses yet"
      else
        puts "You Guessed: #{event[:guess]}"

        hit = event[:hits].include?(event[:guess])
        if hit
          puts "Nice! You got a hit!"
        else
          puts "Sorry, you got a miss"
        end

        puts
        puts "Misses: #{event[:misses]}"
        puts "~~~~~~~~~"
      end
    end

    def won_game?(event)
      event[:hits].sort == event[:random_word].split('').uniq.sort
    end

    def lost_game?(event)
      event[:misses].length >= 6
    end
  end
end