class Term < ActiveRecord::Base
  @@class_name ||= "Term"
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
  has_many :lectures, :class_name => "Lecture", :dependent => :destroy
  has_many :tutorial_schedules, :class_name => "TutorialSchedule", :dependent => :destroy
  has_many :agatha_emails, :class_name => "AgathaEmail", :dependent => :destroy
  has_many :group_terms, :class_name => "GroupTerm", :dependent => :destroy
  belongs_to :term_name, :class_name => "TermName", :foreign_key => "term_name_id"
end
