class CreateGroupLocations < ActiveRecord::Migration
  def self.up
    create_table :group_locations do |t|
      t.integer :group_id, :default => 1
      t.integer :location_id, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :group_locations
  end
end
