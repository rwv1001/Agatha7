class AddPersonIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :person_id, :integer, :default => 1
  end

  def self.down
    remove_column :users, :person_id
  end
end
