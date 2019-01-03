require_relative '../libraries.rb'

require_relative '../views/game_renderer.rb'
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
                :last_guess,
                :events

  def initialize(pub_sub: nil)
    @game_id = SecureRandom.uuid
    @player_name = nil
    @game_filepath = nil
    @completed_game = false
    @random_word = RANDOM_WORDS.sample
    @hits = []
    @misses = []
    @last_guess = nil
    @pub_sub = pub_sub
    @events = []
  end

  def start_game
    display_welcome_message
    setup_folder_and_file_for_new_game

    loop do
      puts "Please guess a letter"
      puts "(type quit end game)"
      user_input = gets.chomp.downcase
      exit_game if user_input == "quit"

      hit = self.random_word.include?(user_input)
      self.last_guess = user_input

      if hit
        self.hits << user_input
      else
        self.misses << user_input
      end

      event = build_event
      publish_event(event)
      save_event(event)
      save_game

      exit if won_game?
      exit if lost_game?
    end
  end

  private

  def won_game?
    self.hits.sort == self.random_word.split('').uniq.sort
  end

  def lost_game?
    self.misses.length >= 6
  end

  def build_event
    {
      "timestamp": Time.now.utc,
      "game_id": self.game_id,
      "player": self.player_name,
      "random_word": self.random_word,
      "hits": self.hits.dup,
      "misses": self.misses.dup,
      "guess": self.last_guess.dup
    }
  end

  def publish_event(event)
    self.pub_sub.publish(event)
  end

  def save_event(event)
    self.events << event
  end

  def save_game
    json = {
      events: self.events
    }

    File.open(self.game_filepath, "w+") do |f|
      f.write(JSON.generate(json))
    end
  end

  def exit_game
    puts "Thanks for playing!"

    # if self.game_filepath and !self.completed_game
    #   remove_gamefile
    #   puts "Not saving your game (since you didn't finish)"
    #   exit
    # end
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
    player_name_input = gets.chomp.downcase
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
    time_now = Time.now.iso8601
    game_folder_path = "_events/#{player_name_input}/#{today_date}"
    FileUtils.mkdir_p(game_folder_path)

    # create game file
    self.game_filepath = game_folder_path + "/#{time_now}.json"
    FileUtils.touch(self.game_filepath)
  end
end
