class RemoveMark < ActiveRecord::Migration
  def self.up
    remove_column :tutorials, :mark
  end

  def self.down
    add_column :tutorials, :mark, :string
  end
end
