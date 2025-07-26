class AddReligioushouseToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :religious_house, :integer, :default => 1
  end

  def self.down
    remove_column :people, :religious_house
  end
end
