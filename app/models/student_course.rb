class StudentCourse < ActiveRecord::Base
  belongs_to :person
  belongs_to :course
  belongs_to :programme
end
