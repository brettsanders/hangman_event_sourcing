require 'securerandom'
require 'json'
require 'pry'

require_relative 'helpers/events'

# Given a Ledger of Events
# Provide ability to View the Game state
events_file = "winning_game"
file = File.read("test_data/#{events_file}.json")
json = JSON.parse (file)
events = json["events"]

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
    puts "... press enter for next event"
    puts "... (or exit to break)"
    total_events_count = events.length

    events.each_with_index do |event, index|
      puts
      puts "[event #{index+1} of #{total_events_count}]"
      puts

      p event

      unless total_events_count == index
        input = gets.chomp
        break if input == "exit"
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