class GroupAttendeeUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE group_attendees ADD CONSTRAINT unique_group_attendees UNIQUE (group_id, attendee_id); "
 end

  def self.down
     execute "ALTER TABLE group_attendees DROP CONSTRAINT unique_group_attendees;"
  end
end

