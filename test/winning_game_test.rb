require_relative '../libraries'

require_relative '../domain_logic/pub_sub.rb'

require_relative '../views/game_renderer.rb'
require_relative '../views/dude_game_renderer.rb'
require_relative '../domain_logic/scoring/leaderboard_helper.rb'
require_relative '../domain_logic/scoring/complexity.rb'
require_relative '../domain_logic/scoring/streaks.rb'
require_relative '../domain_logic/scoring/speed.rb'

# Todo: Hack for now
# Move this into a Config and write to separate files (one for Replay another for Test)
ENV['DO_NOT_UPDATE_LEADERBOARD'] = "true"

# Given a Ledger of Events
# Provide ability to View the Game state
events_file = "winning_game"
file = File.read("test/#{events_file}.json")
json = JSON.parse(file, symbolize_names: true)

# Get the Events from the JSON
events = json[:events]
total_gameplay_events_count = events.length

# Subscribers
scoring_complexity_handler = Scoring::Complexity.new
scoring_speed_handler      = Scoring::Speed.new
scoring_streak_handler     = Scoring::Streaks.new

pub_sub = PubSub.new(subscribers: [
  scoring_complexity_handler,
  scoring_speed_handler,
  scoring_streak_handler,
  Views::GameRenderer.new,
  # Views::DudeGameRenderer.new,
])

# Publish all Events
events.each {|event| pub_sub.publish(event) }

# - - - - - - - - - - - - - - - - - - - - - - - - -
# TESTS
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Assertions
if scoring_streak_handler.games_and_score_data == {"30a28b0d-9752-4ccf-a620-cf08c617cae4"=>{:score=>120, :streak=>2}}
  puts "passing: score & streak for single game\n"
else
  puts "FAIL: score & streak for single game\n"
end

# View Raw Events
# could extract this to an "event viewer"
# events.each_with_index do |event, index|
#   puts
#   puts "[event #{index+1} of #{total_gameplay_events_count}]"
#   puts
#   p event
# end