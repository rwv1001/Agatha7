class GroupTutorialUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE group_tutorials ADD CONSTRAINT unique_group_tutorials UNIQUE (group_id, tutorial_id); "
 end

  def self.down
     execute "ALTER TABLE group_tutorials DROP CONSTRAINT unique_group_tutorials;"
  end
end
