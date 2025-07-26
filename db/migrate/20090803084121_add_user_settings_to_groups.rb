class AddUserSettingsToGroups < ActiveRecord::Migration
 def self.up
    add_column :groups, :owner_id, :integer, :default => 1
    add_column :groups, :private, :boolean
    add_column :groups, :readers_id, :integer, :default => 1
    add_column :groups, :writers_id, :integer, :default => 1
  end

  def self.down
    remove_column :groups, :owner_id
    remove_column :groups, :readers_id
    remove_column :groups, :writers_id
  end
end
