class ChangeMarkAgain < ActiveRecord::Migration
  def self.up

      change_column :tutorials, :mark, :string
  end

  def self.down

      change_column :tutorials, :mark, :integer
  end
end
