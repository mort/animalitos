class CreateLikings < ActiveRecord::Migration
  def up
    create_table :likings do |t|
      t.integer :animalito_id
      t.string :uri
      t.string :liking_type
      t.string :sign
      t.timestamps
    end
  end

  def down
    drop_table :likings
  end
end
