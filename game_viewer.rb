require_relative 'libraries'
require_relative 'views/game_renderer.rb'
require_relative 'domain_logic/aggregates/game_scorer.rb'
require_relative 'domain_logic/pub_sub.rb'

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

if ARGV.any?
  file = File.read(ARGV.shift)
else
  # Given a Ledger of Events
  # Provide ability to View the Game state
  events_file = "winning_game"
  file = File.read("test/#{events_file}.json")
end

json = JSON.parse(file, symbolize_names: true)
events = json[:events]

end_session = false

puts
puts "** Welcome to Event Replay **"
puts

until end_session
  puts "- - - - - - - - - "
  puts "what would you like to do?"
  puts "enter command (begin_replay, view_all_events, view_at, exit):"
  puts

  user_input = gets.chomp

  case user_input
  when "exit"
    end_session = true
  when "begin_replay"
    puts
    puts "... enter for next (exit to break)"
    total_events_count = events.length

    events.each_with_index do |event, index|
      puts
      puts "[event #{index+1} of #{total_events_count}]"
      puts

      p event
      puts "publishing_event..."
      pub_sub.publish(event)

      unless total_events_count == index
        puts "...next, exit, or back"
        input = gets.chomp
        case input
        when "exit"
          break
        when "next"
          next
        end
      end
    end

    puts "[end of events stream]"

  when "view_all_events"
    pp events
  when "view_at"
    puts "enter timestamp:"
    input_timestamp = gets.chomp.strip.tr('"', '')
    pp events.select{|event| event["timestamp"] == input_timestamp}
  end
end