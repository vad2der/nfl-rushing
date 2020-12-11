class CreatePositions < ActiveRecord::Migration[6.0]
  def change
    create_table :positions do |t|
      t.string :name
      t.string :abbr

      t.timestamps
    end
  end
end
