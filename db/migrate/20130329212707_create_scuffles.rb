class CreateScuffles < ActiveRecord::Migration
  def up
    create_table :scuffles do |t|
      t.integer :a1_id
      t.integer :a2_id
      t.boolean :over
      t.boolean :tie
      t.integer :winner_id
      t.integer :loser_id
      t.integer :location_id
      t.timestamps
    end
  end

  def down
    drop_table :scuffles
  end
end
