require_relative '../assets/images.rb'

module ReadModel
  class GameRenderer
    def call(event)

      puts IMAGES[event[:misses].length]

      if event[:guess] == "" or event[:guess].nil?
        puts "Game is beginning..."
        puts "You have made no guesses yet"
      else
        hit_or_miss = event[:hits].include?(event[:guess]) ? "hit" : "miss"
        puts
        puts "Your word: (#{event[:random_word].length} letters long)"
        puts event[:random_word].split('').map{|c| event[:hits].include?(c) ? c + " " : "_ "}.join()
        puts
        puts "You Guessed: #{event[:guess]}"
        puts "Hit or Miss? " + hit_or_miss.upcase
        puts "Misses: #{event[:misses]}"
        puts "~~~~~~~~~"
      end
    end
  end
end