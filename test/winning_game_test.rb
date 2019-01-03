require_relative '../libraries'

require_relative '../views/game_renderer.rb'
require_relative '../domain_logic/aggregates/game_scorer.rb'
require_relative '../domain_logic/pub_sub.rb'

# Given a Ledger of Events
# Provide ability to View the Game state
events_file = "winning_game"
file = File.read("test/#{events_file}.json")
json = JSON.parse(file, symbolize_names: true)

# Get the Events from the JSON
events = json[:events]
total_events_count = events.length

# Subscribers
game_renderer = Views::GameRenderer.new
game_scorer = Aggregate::GameScorer.new

# Read Models would need to come after the domain_logic handlers
# In Rails, this is handled via the Request/Response flow
pub_sub = PubSub.new(
  subscribers: [
    game_scorer,
  ],
  view: [
    game_renderer
  ]
)

events.each {|event| pub_sub.publish(event) }

# View Raw Events
# could extract this to an "event viewer"
# events.each_with_index do |event, index|
#   puts
#   puts "[event #{index+1} of #{total_events_count}]"
#   puts
#   p event
# end

# - - - - - - - - - - - - - - - - - - - - - - - - -
# TESTS
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Assertions
if game_scorer.games_and_score_data == {"30a28b0d-9752-4ccf-a620-cf08c617cae4"=>{:score=>120, :streak=>2}}
  puts "passing: score & streak for single game\n"
else
  puts "FAIL: score & streak for single game\n"
end
