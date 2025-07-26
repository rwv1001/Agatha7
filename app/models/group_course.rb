class GroupCourse < ActiveRecord::Base
  @@class_name ||= "GroupCourse"
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
  belongs_to :course,  :class_name => "Course", :foreign_key => "course_id"
  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
end
