class Leaderboard
  def self.update_leaderboard(player:, score:)
    if ENV["DO_NOT_UPDATE_LEADERBOARD"]
      puts "NOTE: ENV['DO_NOT_UPDATE_LEADERBOARD'] is set to true"
      return
    end

    leaderboard = csv_to_hash

    if leaderboard[player]
      leaderboard[player] += score
    else
      leaderboard[player] = score
    end

    hash_to_csv(leaderboard)
  end

  def self.hash_to_csv(hash)
    sorted_by_score = hash.to_a.map{|h| [h[1], h[0]]}.sort.reverse

    CSV.open("domain_logic/scoring/_leaderboard.csv", "w") do |csv|
      sorted_by_score.each do |s|
        csv << s
      end
    end
  end

  def self.csv_to_hash
    data = {}
    CSV.foreach("domain_logic/scoring/_leaderboard.csv") do |row|
      score = row[0].to_i
      name = row[1]

      data[name] = score
    end

    data
  end

end
