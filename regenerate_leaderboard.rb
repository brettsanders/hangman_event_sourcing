require_relative 'libraries'

require_relative 'domain_logic/pub_sub.rb'

require_relative 'views/game_renderer.rb'
require_relative 'views/dude_game_renderer.rb'
require_relative 'domain_logic/scoring/leaderboard.rb'
require_relative 'domain_logic/scoring/complexity.rb'
require_relative 'domain_logic/scoring/streaks.rb'
require_relative 'domain_logic/scoring/speed.rb'

# Subscribers
scoring_complexity_handler = Scoring::Complexity.new
scoring_speed_handler      = Scoring::Speed.new
scoring_streak_handler     = Scoring::Streaks.new

# Setup Pub Sub
pub_sub = PubSub.new(subscribers: [
  scoring_complexity_handler,
  scoring_speed_handler,
  scoring_streak_handler,
  # Views::GameRenderer.new, # no need to view the game
])

# Get Filepaths for all Game Events
gameplay_event_filepaths = Dir.glob('_gameplay_events/**/*').select{ |e| File.file? e }

# Show User Filepaths; Ask if want to proceed to regenerate Leaderboard
puts "Found #{gameplay_event_filepaths.length} gameplay event files to process"
puts "Do you want to regenerate the leaderboard from the following?"
pp gameplay_event_filepaths
puts
puts "Enter Y to proceed"

confirmation_input = gets.chomp.downcase

exit unless confirmation_input == 'y'

filecount = 1
total_filepaths = gameplay_event_filepaths.length

gameplay_event_filepaths.each do |filepath|
  file = File.read(filepath)
  json = JSON.parse(file, symbolize_names: true)
  game_events = json[:events]

  puts
  puts "- - - - - - - - - - - "
  puts "PROCESSING FILE #{filecount} of #{total_filepaths}"
  puts "filepath: #{filepath}"
  puts

  total_game_events = game_events.length
  game_event_num = 1
  game_events.each do |game_event|
    puts "publishing event (#{game_event_num} of #{total_game_events})"
    p game_event
    pub_sub.publish(game_event)

    game_event_num += 1
  end

  filecount += 1
end