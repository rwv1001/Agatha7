class GroupLocationUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE group_locations ADD CONSTRAINT unique_group_locations UNIQUE (group_id, location_id); "
 end

  def self.down
     execute "ALTER TABLE group_locations DROP CONSTRAINT unique_group_locations;"
  end
end
