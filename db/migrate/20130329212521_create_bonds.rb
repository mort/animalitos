class CreateBonds < ActiveRecord::Migration
  def up
    create_table :bonds do |t|
      t.integer :player_id
      t.integer :animalito_id
      t.timestamps
    end
  end

  def down
    drop_table :bonds
  end
end
