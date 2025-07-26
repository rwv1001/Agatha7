class CreateGroupLectures < ActiveRecord::Migration
  def self.up
    create_table :group_lectures do |t|
      t.integer :group_id, :default => 1
      t.integer :lecture_id, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :group_lectures
  end
end
