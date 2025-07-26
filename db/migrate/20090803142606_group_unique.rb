class GroupUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE groups ADD CONSTRAINT unique_groups UNIQUE (group_name, table_name); "
 end

  def self.down
     execute "ALTER TABLE groups DROP CONSTRAINT unique_groups;"
  end
end
