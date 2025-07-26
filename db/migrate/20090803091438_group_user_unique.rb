class GroupUserUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE group_users ADD CONSTRAINT unique_group_users UNIQUE (group_id, user_id); "
 end

  def self.down
     execute "ALTER TABLE group_users DROP CONSTRAINT unique_group_users;"
  end
end
