class Attendee < ActiveRecord::Base
  @@class_name ||= "Attendee"
def class_name
  return @@class_name
end
def self.set_controller(search_controller_)
  @@search_controller = search_controller_
end

def search_controller
  return @@search_controller
end
    USER_WHERE_STR = "";
    belongs_to :student,  :class_name => "Person", :foreign_key => "person_id"
    belongs_to :lecture,  :class_name => "Lecture", :foreign_key => "lecture_id"
    has_many :group_attendees, :class_name => "GroupAttendee", :dependent => :destroy
end
