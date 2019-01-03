require_relative './domain_logic/game_manager.rb'

pub_sub = PubSub.new(
  subscribers: [
    Scoring::Complexity.new,
    Scoring::Speed.new,
    Scoring::Streaks.new,
    Views::GameRenderer.new,
    # Views::DudeGameRenderer.new,
  ]
)
game_manager = GameManager.new(pub_sub: pub_sub)
game_manager.start_game