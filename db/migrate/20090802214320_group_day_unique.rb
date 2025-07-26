class GroupDayUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE group_days ADD CONSTRAINT unique_group_days UNIQUE (group_id, day_id); "
 end

  def self.down
     execute "ALTER TABLE group_days DROP CONSTRAINT unique_group_days;"
  end
end
