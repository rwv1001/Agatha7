class WillingTeacher < ActiveRecord::Base
  @@class_name ||= "WillingTeacher"
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
end
