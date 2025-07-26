class AddNotesToTutorials < ActiveRecord::Migration
  def self.up
    add_column :tutorials, :notes, :text
  end

  def self.down
    remove_column :tutorials, :notes
  end
end
