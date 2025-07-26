class Lecture < ActiveRecord::Base
  @@class_name ||= "Lecture"
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
   
    belongs_to :lecturer, :class_name => "Person", :foreign_key => "person_id"
    belongs_to :course, :class_name => "Course", :foreign_key => "course_id"
    belongs_to :term, :class_name => "Term", :foreign_key => "term_id"
    belongs_to :day, :class_name => "Day", :foreign_key => "day_id"
    belongs_to :location, :class_name => "Location", :foreign_key => "location_id"
    has_many :attendees, :class_name => "Attendee", :dependent => :destroy
    has_many :students, :class_name => "Person", :through => :attendees
    has_many :group_lectures, :class_name => "GroupLecture", :dependent => :destroy
    
end
