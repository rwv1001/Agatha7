class AddParamsToAttendees < ActiveRecord::Migration
  def self.up
    add_column :attendees, :compulsory, :boolean
    add_column :attendees, :mark, :integer
    add_column :attendees, :mark_type, :integer
  end

  def self.down
    remove_column :attendees, :mark_type
    remove_column :attendees, :mark
    remove_column :attendees, :compulsory
  end
end
