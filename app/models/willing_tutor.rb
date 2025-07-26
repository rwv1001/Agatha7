class WillingTutor < ActiveRecord::Base
  @@class_name ||= "WillingTutor"
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
  belongs_to :course, :class_name => "Course", :foreign_key => "course_id"
  belongs_to :tutor, :class_name => "Person", :foreign_key => "person_id"
  has_many :group_willing_tutors, :class_name => "GroupWillingTutor", :dependent => :destroy
end
