file = File.read('./db/rushing.json')
json_data = JSON.parse(file)

# I suggest that 1 player can be in a single team only, as long as the provided data supports it
# if a player can appear in several teams - many-to-many with join table to be used
puts "%s %s" % ['Number of records in the source file: ', json_data.size]

def populate_data(data)
  team = Team.create({abbr: data['Team']})
  position = Position.create({abbr: data['Pos']})
  player = Player.create({full_name: data['Player'], team_id: team.id})
  
  lng = data['Lng'].to_s.split('T').first.to_i
  tochdown = data['Lng'].to_s.include?('T')

  RushStat.create({
      player_id:             player.id,
      position_id:           position.id,
      attempts_per_game:     data['Att/G'].to_i,
      attempts:              data['Att'].to_f,
      total_yards:           data['Yds'].to_i,
      avg_yards_per_attempt: data['Avg'].to_f,
      yards_per_game:        data['Avg/G'].to_f,
      total_touchdowns:      data['TD'].to_i,
      longest:               lng,
      touchdown:             tochdown,
      first_down:            data['1st'].to_i,
      first_down_percent:    data['1st%'].to_f,
      twenty_yards_each:     data['20+'].to_i,
      forty_yards_each:      data['40+'].to_i,
      fumbles:               data['FUM'].to_i
  })
rescue => err
  puts "===ERROR==="
  puts err
  throw err
end

json_data.each do |data|
  populate_data(data)
end
