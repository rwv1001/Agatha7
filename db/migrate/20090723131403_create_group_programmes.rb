class CreateGroupProgrammes < ActiveRecord::Migration
  def self.up
    create_table :group_programmes do |t|
      t.integer :group_id
      t.integer :programme_id

      t.timestamps
    end
  end

  def self.down
    drop_table :group_programmes
  end
end
