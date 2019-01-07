require_relative 'libraries'

require_relative 'domain_logic/pub_sub.rb'

require_relative 'views/game_renderer.rb'
require_relative 'views/dude_game_renderer.rb'
require_relative 'domain_logic/scoring/leaderboard.rb'
require_relative 'domain_logic/scoring/complexity.rb'
require_relative 'domain_logic/scoring/streaks.rb'
require_relative 'domain_logic/scoring/speed.rb'

# Todo: Hack for now
# Move this into a Config and write to separate files (one for Replay another for Test)
ENV['DO_NOT_UPDATE_LEADERBOARD'] = "true"

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
  puts "enter command (begin_replay, view_all_gameplay_events, view_at, exit):"
  puts

  user_input = gets.chomp

  case user_input
  when "exit"
    end_session = true
  when "begin_replay"
    puts
    puts "... enter for next (exit to break)"
    total_gameplay_events_count = events.length

    events.each_with_index do |event, index|
      puts
      puts "[event #{index+1} of #{total_gameplay_events_count}]"
      puts

      p event
      puts "publishing_event..."
      pub_sub.publish(event)

      unless total_gameplay_events_count == index
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

  when "view_all_gameplay_events"
    pp events
  when "view_at"
    puts "enter timestamp:"
    input_timestamp = gets.chomp.strip.tr('"', '')
    pp events.select{|event| event["timestamp"] == input_timestamp}
  end
end