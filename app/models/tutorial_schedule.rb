class TutorialSchedule < ActiveRecord::Base
  @@class_name ||= "TutorialSchedule"
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
   
  belongs_to :tutor, :class_name => "Person", :foreign_key => "person_id"
  belongs_to :course, :class_name => "Course", :foreign_key => "course_id"
  belongs_to :term, :class_name => "Term", :foreign_key => "term_id"
 

  has_many :tutorials, :class_name => "Tutorial", :dependent => :destroy
  has_many :students, :class_name => "Person", :through => :tutorials
  has_many :group_tutorial_schedules, :class_name => "GroupTutorialSchedule", :dependent => :destroy
  
end
