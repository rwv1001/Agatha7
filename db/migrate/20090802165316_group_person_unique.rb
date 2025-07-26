class GroupPersonUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE group_people ADD CONSTRAINT unique_group_people UNIQUE (group_id, person_id); "
 end

  def self.down
     execute "ALTER TABLE group_people DROP CONSTRAINT unique_group_people;"
  end
end
