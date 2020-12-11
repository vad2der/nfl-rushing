class RushStat < ApplicationRecord
  belongs_to :player
  belongs_to :position

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  __elasticsearch__.client = Elasticsearch::Client.new :log => true

  # elasticsearch settings mapping
  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes player: [:full_name], type: 'string', analyzer: 'english'
      indexes :id, type: 'integer'
      indexes :total_yards, type: 'integer'
      indexes :longest, type: 'integer'
      indexes :total_touchdowns, type: 'integer'
    end
  end

  # elasticsearch indexing
  def as_indexed_json(options={})
    self.as_json(
      only: [
        :id,
        :position,
        :attempts,
        :attempts_per_game,
        :total_yards, 
        :avg_yards_per_attempt,
        :yards_per_game,
        :total_touchdowns,
        :longest,
        :touchdown,
        :first_down,
        :first_down_percent,
        :twenty_yards_each,
        :forty_yards_each,
        :fumbles
      ],
      include: {
        player: {
          only: [:full_name],
          include: {
            team: {
              only: [:abbr]
            }
          }
        },
        position: {
          only: [:abbr]
        }
      }
    )
  end

  def self.search_by_name(query='*', sort_by='id', order='asc', from, size)
    case sort_by
    when 'total_yards'
      sort_hash = {total_yards: order}
    when 'total_touchdowns'
      sort_hash = {total_touchdowns: order}
    when 'longest'
      sort_hash = {longest: order}
    else
      sort_hash = {id: order}
    end

    if query == '*'
      query_hash = {match_all: {}}
    else
      query_hash = {
        multi_match: {
          query: query,
          fields: ['player.full_name']
        }
      }
    end

    players = []
    records = self.__elasticsearch__.search(
      {
        query: query_hash,
        sort: sort_hash
      }
    ).results.total

    if records % size > 0
      pages = 1 + records / size
    else
      pages = records / size
    end

    self.__elasticsearch__.search(
      {
        query: query_hash,
        sort: sort_hash,
        from: from,
        size: size
      }
    ).each do |rs|
      r = JSON.parse(rs["_source"].to_json)
      touchdown = r["touchdown"] ? "T" : ""
      players << {
        "id": r["id"],
        "Player": r["player"]["full_name"],
        "Team": r["player"]["team"]["abbr"],
        "Pos": r["position"]["abbr"],
        "Att": r["attempts"],
        "Att/G": r["attempts_per_game"],
        "Yds": r["total_yards"],
        "Avg": r["avg_yards_per_attempt"],
        "Yds/G": r["yards_per_game"],
        "TD": r["total_touchdowns"],
        "Lng": r["longest"].to_s + touchdown,
        "1st": r["first_down"],
        "1st%": r["first_down_percent"],
        "20+": r["twenty_yards_each"],
        "40+": r["forty_yards_each"],
        "FUM": r["fumbles"]
      }
    end

    return {players: players, length: records, pages: pages}
  end

  def self.index_all
    self.all.each {|rs| rs.__elasticsearch__.index_document}
  end
end
