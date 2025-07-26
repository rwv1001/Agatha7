class Location < ActiveRecord::Base
  @@class_name ||= "Location"
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
  has_many :group_locations, :class_name => "GroupLocation", :dependent => :destroy
end
