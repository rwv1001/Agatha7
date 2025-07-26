class Tutorial < ActiveRecord::Base
  @@class_name ||= "Tutorial"
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
  belongs_to :student, :class_name => "Person", :foreign_key => "person_id"
  belongs_to :tutorial_schedule, :class_name => "TutorialSchedule", :foreign_key => "tutorial_schedule_id"
  has_many :group_tutorials, :class_name => "GroupTutorial", :dependent => :destroy
end
