class Person < ActiveRecord::Base

@@class_name ||= "Person"
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
  


  has_many :tutorial_schedules, :class_name =>"TutorialSchedule", :dependent => :destroy
  has_many :tutorials, :class_name => "Tutorial", :dependent => :destroy
  has_many :lecture_schedules, :class_name =>"Lecture",  :dependent => :destroy
  has_many :attendees, :class_name => "Attendee", :dependent => :destroy
  has_many :group_people, :class_name => "GroupPerson", :dependent => :destroy
  has_many :users, :class_name => "User", :dependent => :destroy
  has_many :agatha_emails, :class_name => "AgathaEmail", :dependent => :destroy
  has_many :maximum_tutorials, :class_name => "MaximumTutorial", :dependent => :destroy
  has_many :willing_lecturers, :class_name => "WillingLecturer", :dependent => :destroy
  has_many :willing_tutors, :class_name => "WillingTutor", :dependent => :destroy

  belongs_to :entry_term, :class_name => "Term", :foreign_key => "entry_term_id"
  belongs_to :institution, :class_name => "Institution", :foreign_key => "institution_id"
  belongs_to :religious_house, :class_name => "Institution", :foreign_key => "religious_house_id"

  has_many :groups, :class_name => "Group", :through => :group_people










end
