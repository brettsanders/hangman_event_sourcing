require_relative '../assets/images.rb'

module Views
  class DudeGameRenderer
    def call(event)

      puts IMAGES[event[:misses].length]
      puts "DUDE Your word: (#{event[:random_word].length} letters long)"
      puts event[:random_word].split('').map{|c| event[:hits].include?(c) ? c + " " : "_ "}.join()

      if won_game?(event)
        puts "DUDE Congratulations! You won the game"
      end

      if lost_game?(event)
        puts "DUDE Sorry, you lost"
      end

      if event[:guess] == "" or event[:guess].nil?
        puts "DUDE Game is beginning..."
        puts "DUDE You have made no guesses yet"
      else
        puts "DUDE You Guessed: #{event[:guess]}"

        hit = event[:hits].include?(event[:guess])
        if hit
          puts "DUDE Nice! You got a hit!"
        else
          puts "DUDE Sorry, you got a miss"
        end

        puts
        puts "DUDE Misses: #{event[:misses]}"
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