class CreateScores < ActiveRecord::Migration
  def up
    create_table :scores do |t|
      t.integer :animalito_id
      t.string  :name
      t.integer :max_value
      t.integer :min_value
      t.timestamps
    end
  end

  def down
    drop_table :scores
  end
end
