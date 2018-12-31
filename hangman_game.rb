require 'securerandom'

end_game = false

until end_game == true
  puts "Welcome to Hangman"
  puts "Should I end the game? (Y/N)"

  end_game_input = gets.chomp
  end_game = "Y" ? true : false
end