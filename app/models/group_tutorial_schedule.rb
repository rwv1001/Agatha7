class GroupTutorialSchedule < ActiveRecord::Base
  @@class_name ||= "GroupTutorialSchedule"
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
  belongs_to :tutorial_schedule,  :class_name => "TutorialSchedule", :foreign_key => "tutorial_schedule_id"
  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
end
