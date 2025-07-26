class CreateGroupUsers < ActiveRecord::Migration
  def self.up
    create_table :group_users do |t|
      t.integer :group_id, :default => 1
      t.integer :user_id, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :group_users
  end
end
