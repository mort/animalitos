class CreatePositions < ActiveRecord::Migration
  def up
    create_table :positions do |t|
      t.integer :location_id 
      t.integer :actor_id
      t.string  :actor_type
      t.timestamps
    end
    
  end

  def down
    drop_table :positions
  end
end
