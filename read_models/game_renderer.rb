require_relative '../assets/images.rb'

module ReadModel
  class GameRenderer
    def call(event)
      if event["guess"] == ""
        "Game is beginning..."
      else
        hit_or_miss = event["hits"].include?(event["guess"]) ? "hit" : "miss"

        puts IMAGES[event["misses"].length]
        puts
        puts "Your word: (#{event["random_word"].length} letters long)"
        puts event["random_word"].split('').map{|c| event["hits"].include?(c) ? c + " " : "_ "}.join()
        puts
        puts "You Guessed: #{event["guess"]}"
        puts "Hit or Miss? " + hit_or_miss.upcase
        puts "Misses: #{event["misses"]}"
        puts "~~~~~~~~~"
      end
    end
  end
end