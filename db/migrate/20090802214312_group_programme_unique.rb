class GroupProgrammeUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE group_programmes ADD CONSTRAINT unique_group_programmes UNIQUE (group_id, programme_id); "
 end

  def self.down
     execute "ALTER TABLE group_programmes DROP CONSTRAINT unique_group_programmes;"
  end
end

