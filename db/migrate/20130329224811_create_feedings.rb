class CreateFeedings < ActiveRecord::Migration
  def up
    create_table :feedings do |t|
      t.integer :animalito_id
      t.string :img_url
      t.integer :luma_value
      t.timestamps
    end
  end

  def down
    drop_table :feedings
  end
end
