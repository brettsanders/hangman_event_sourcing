require_relative '../libraries.rb'

require_relative '../read_models/game_renderer.rb'
require_relative 'aggregates/game_scorer.rb'
require_relative 'pub_sub.rb'

class GameManager
  attr_accessor :end_game,
                :game_id,
                :player_name,
                :game_filepath,
                :completed_game

  def initialize
    @game_id = SecureRandom.uuid
    @player_name = nil
    @game_filepath = nil
    @completed_game = false
  end

  def start_game
    display_welcome_message
    setup_folder_and_file_for_new_game

    # Game Loop
    loop do
      puts "End game? (Y/N)"
      end_game_input = gets.chomp
      exit_game if end_game_input == "Y"
    end
  end

  private

  def exit_game
    puts "Thanks for playing!"

    if self.game_filepath and !self.completed_game
      remove_gamefile
      puts "Not saving your game (since you didn't finish)"
      exit
    end
  end

  def remove_gamefile
    FileUtils.remove_file(self.game_filepath)
  end

  def display_welcome_message
    puts "Welcome to Hangman"
    puts "Type 'quit' to end the game at any time"
  end

  def setup_folder_and_file_for_new_game
    puts "What is your player_name?"
    player_name_input = gets.chomp
    self.player_name = player_name_input
    exit if player_name_input == "quit"

    # create a folder for the User
    FileUtils.mkdir_p "_events/#{player_name_input}"

    already_played = Dir["_events/#{player_name_input}/*"].length
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
    game_folder_path = "_events/#{player_name_input}/#{today_date}"
    FileUtils.mkdir_p(game_folder_path)

    # create game file
    self.game_filepath = game_folder_path + "/#{game_id}.rb"
    FileUtils.touch(self.game_filepath)
  end
end
