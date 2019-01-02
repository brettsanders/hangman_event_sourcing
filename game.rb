require_relative './domain_logic/game_manager.rb'

pub_sub = PubSub.new(
  subscribers: [Aggregate::GameScorer.new],
  read_models: [ReadModel::GameRenderer.new]
)
game_manager = GameManager.new(pub_sub: pub_sub)
game_manager.start_game