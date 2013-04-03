class CreateJourneysLocations < ActiveRecord::Migration
  def up
    create_table :journeys_locations do |t|
      t.integer :journey_id
      t.integer :location_id
      t.timestamps
    end
  end

  def down
    drop_table :journeys_locations
  end
end
