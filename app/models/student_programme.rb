class StudentProgramme < ActiveRecord::Base
    belongs_to :person
    belongs_to :programme
end
