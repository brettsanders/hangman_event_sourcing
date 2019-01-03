module LeaderboardHelper
  def update_leaderboard(player:, score:)
    leaderboard = csv_to_hash

    if leaderboard[player]
      leaderboard[player] += score
    else
      leaderboard[player] = score
    end

    hash_to_csv(leaderboard)
  end

  def hash_to_csv(hash)
    sorted_by_score = hash.to_a.map{|h| [h[1], h[0]]}.sort.reverse

    CSV.open("domain_logic/scoring/_leaderboard.csv", "w") do |csv|
      sorted_by_score.each do |s|
        csv << s
      end
    end
  end

  def csv_to_hash
    data = {}
    CSV.foreach("domain_logic/scoring/_leaderboard.csv") do |row|
      score = row[0].to_i
      name = row[1]

      data[name] = score
    end

    data
  end
end
