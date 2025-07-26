class ChangeMarks < ActiveRecord::Migration
  def self.up
      change_column :tutorials, :mark, :string
      change_column :tutorials, :mark_type, :string
  end

  def self.down
      change_column :tutorials, :mark, :integer
      change_column :tutorials, :mark_type, :integer
  end
end
