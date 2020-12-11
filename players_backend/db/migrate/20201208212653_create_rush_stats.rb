class CreateRushStats < ActiveRecord::Migration[6.0]
  def change
    create_table :rush_stats do |t|
      t.integer :attempts_per_game
      t.decimal :attempts, :precision => 4, :scale => 1
      t.integer :total_yards
      t.decimal :avg_yards_per_attempt, :precision => 4, :scale => 1
      t.decimal :yards_per_game, :precision => 4, :scale => 1
      t.integer :total_touchdowns
      t.integer :longest
      t.boolean :touchdown
      t.integer :first_down
      t.decimal :first_down_percent, :precision => 4, :scale => 1
      t.integer :twenty_yards_each
      t.integer :forty_yards_each
      t.integer :fumbles
      t.references :player, null: false, foreign_key: true
      t.references :position, null: false, foreign_key: true

      t.timestamps
    end
  end
end
