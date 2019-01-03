require 'csv'
require 'json'
require 'pry'

leaders = {}
CSV.open("./domain_logic/scoring/_leaderboard.csv").each do |row|
  score = row[0]
  name = row[1]

  leaders[name] = score
end

JSON.parse(leaders)