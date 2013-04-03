class CreateLocations < ActiveRecord::Migration
  def up
    create_table :locations do |t|
      t.string :geohash
      t.string :csquare
      t.float  :lat
      t.float  :lon
      t.float  :true_lat
      t.float  :true_lon
      t.integer :altitude
      t.timestamps
    end
    
  end

  def down
    drop_table :locations
  end
end
