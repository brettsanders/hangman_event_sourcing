require_relative '../libraries.rb'

require_relative '../read_models/game_renderer.rb'
require_relative 'aggregates/game_scorer.rb'
require_relative 'pub_sub.rb'

RANDOM_WORDS = %w(dog cat moose elephant horse gorilla)

class GameManager
  attr_accessor :end_game,
                :game_id,
                :player_name,
                :game_filepath,
                :completed_game,
                :random_word,
                :hits,
                :misses,
                :pub_sub,
                :last_guess

  def initialize
    @game_id = SecureRandom.uuid
    @player_name = nil
    @game_filepath = nil
    @completed_game = false
    @random_word = RANDOM_WORDS.sample
    @hits = []
    @misses = []
    @last_guess = nil

    @pub_sub = PubSub.new(
      subscribers: [Aggregate::GameScorer.new],
      read_models: [ReadModel::GameRenderer.new]
    )

    @game_state = {

    }
  end

  def start_game
    display_welcome_message
    setup_folder_and_file_for_new_game

    loop do
      # capture guess...

      e = build_event
      publish_event(e)

      puts "End game? (Y/N)"
      end_game_input = gets.chomp
      exit_game if end_game_input == "Y"
    end
  end

  private

  def build_event
    {
      "timestamp": Time.now.utc,
      "game_id": self.game_id,
      "player": self.player_name,
      "random_word": self.random_word,
      "hits": self.hits,
      "misses": self.misses,
      "guess": self.last_guess
    }
  end

  def publish_event(event)
    self.pub_sub.publish(event)
  end

  def save_game
    # write to the json file
    # prob easier to just store the whole thing internally and then re-write the file ...
    # {
    #   "timestamp": "2018-12-31 18:13:00 UTC",
    #   "game_id": "30a28b0d-9752-4ccf-a620-cf08c617cae4",
    #   "player": "brett",
    #   "random_word": "dog",
    #   "hits": [],
    #   "misses": [],
    #   "guess": ""
    # }
  end

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
