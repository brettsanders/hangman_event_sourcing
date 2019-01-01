require_relative 'libraries.rb'

require_relative 'read_models/game_renderer.rb'
require_relative 'domain_logic/aggregates/game_scorer.rb'
require_relative 'domain_logic/pub_sub.rb'

end_game = false
puts "Welcome to Hangman"
puts "Type 'quit' to end the game at any time"

puts "What is your username?"
username = gets.chomp

# create a folder for the User
FileUtils.mkdir_p "_events/#{username}"

already_played = Dir["_events/#{username}/*"].length
if already_played
  puts "Looks like you've played before"
  puts "... looks like you're played #{already_played} games before"
end

puts "Do you want to start a new game? (Y/N)"
if gets.chomp == "N"
  puts "OK, maybe later"
  exit
end

# create file for user
today_date = Date.today
game_folder_path = "_events/#{username}/#{today_date}"
FileUtils.mkdir_p(game_folder_path)

# create game file
new_game_id = SecureRandom.uuid
FileUtils.touch(game_folder_path + "/#{new_game_id}.rb")

until end_game
  end_game = gets.chomp
  end_game = end_game == "Y"
end