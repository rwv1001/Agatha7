class AddTableNameToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :table_name, :text
  end

  def self.down
    remove_column :groups, :table_name
  end
end
