class CreatePlayers < ActiveRecord::Migration
  def up
    create_table :players do |t|
      t.string :name
      t.string :uuid
      t.timestamps
    end
  end

  def down
    drop_table :players    
  end
end
