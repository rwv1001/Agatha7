class UserNameUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE users ADD CONSTRAINT unique_users UNIQUE(name); "
 end

  def self.down
     execute "ALTER TABLE users DROP CONSTRAINT unique_users;"
  end
end
