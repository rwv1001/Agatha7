class TermName < ActiveRecord::Base
  @@class_name ||= "TermName"
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
  has_many :terms, :class_name => "Term", :dependent => :destroy
  has_many :group_term_names, :class_name => "GroupTermName", :dependent => :destroy
end
