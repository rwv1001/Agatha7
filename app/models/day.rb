class Day < ActiveRecord::Base
  @@class_name ||= "Day"
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
  has_many :lectures, :class_name => "Lecture", :dependent => :destroy
  has_many :group_days, :class_name => "GroupDay", :dependent => :destroy
end
