class CreateGroupAttendees < ActiveRecord::Migration
  def self.up
    create_table :group_attendees do |t|
      t.integer :group_id, :default => 1
      t.integer :attendee_id, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :group_attendees
  end
end
