class CreateJourneys < ActiveRecord::Migration
  def up
    create_table :journeys do |t|
      t.integer :animalito_id
      t.boolean :open
      t.datetime :created_at
      t.datetime :finished_at
    end
  end

  def down
    drop_table :journeys
  end
end
