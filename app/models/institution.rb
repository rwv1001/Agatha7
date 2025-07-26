class Institution < ActiveRecord::Base
  @@class_name ||= "Institution"
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
  has_many :people, :class_name => "Person", :dependent => :destroy
  has_many :group_institutions, :class_name => "GroupInstitution", :dependent => :destroy
end
