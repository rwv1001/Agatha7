class Course < ActiveRecord::Base
  @@class_name ||= "Course"
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
  
  has_many :tutorial_schedules, :class_name => "TutorialSchedule", :dependent => :destroy
  has_many :lectures, :class_name => "Lecture", :dependent => :destroy
  has_many :agatha_emails, :class_name =>"AgathaEmail", :dependent => :destroy
  has_many :agatha_files, :class_name =>"AgathaFile", :dependent => :destroy
  has_many :group_courses, :class_name => "GroupCourse", :dependent => :destroy
  has_many :willing_lecturers, :class_name => "WillingLecturer", :dependent => :destroy
  has_many :willing_tutors, :class_name => "WillingTutor", :dependent => :destroy
end
