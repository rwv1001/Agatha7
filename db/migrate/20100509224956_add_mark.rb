class AddMark < ActiveRecord::Migration
  def self.up
     add_column :tutorials, :mark, :string
  end

  def self.down
    remove_column :tutorials, :mark
  end
end
