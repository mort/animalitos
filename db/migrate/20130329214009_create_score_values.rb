class CreateScoreValues < ActiveRecord::Migration
  def up
    create_table :score_values do |t|
      t.integer :score_id
      t.integer :value
      t.timestamps
    end
  end

  def down
    drop_table :score_values
  end
end
