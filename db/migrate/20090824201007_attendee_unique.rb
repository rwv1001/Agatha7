class AttendeeUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE attendees ADD CONSTRAINT unique_attendees UNIQUE (person_id, lecture_id); "
 end

  def self.down
     execute "ALTER TABLE attendees DROP CONSTRAINT unique_attendees;"
  end
end
