class AgathaEmail < ActiveRecord::Base
  @@class_name ||= "AgathaEmail"
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
      belongs_to :person,  :class_name => "Person", :foreign_key => "person_id"
      belongs_to :email_template, :class_name => "EmailTemplate", :foreign_key => "email_template_id"
      belongs_to :term, :class_name => "Term", :foreign_key => "term_id"
      belongs_to :course, :class_name => "Course", :foreign_key => "course_id"

      has_many :group_agatha_emails, :class_name => "GroupAgathaEmail", :dependent => :destroy
      has_many :email_attachments, :class_name => "EmailAttachment", :dependent => :destroy
      has_many :agatha_files, :through => :email_attachments
end
