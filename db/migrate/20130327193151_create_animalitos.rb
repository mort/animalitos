class CreateAnimalitos < ActiveRecord::Migration
  def up
    create_table :animalitos do |t|
      t.string :name
      t.string :uuid
      t.boolean :leashed
      t.timestamps
    end
  end

  def down
    drop_table :animalitos
  end
end
