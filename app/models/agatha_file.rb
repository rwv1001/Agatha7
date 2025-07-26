#require 'paperclip'
## File.join(File.dirname(__FILE__),'../../vendor/rails/paperclip/lib/paperclip')
class AgathaFile < ActiveRecord::Base
    @@class_name ||= "AgathaFile"
def class_name
  return @@class_name
end
def self.set_controller(search_controller_)
  @@search_controller = search_controller_
end

def search_controller
  return @@search_controller
end
  #has_attached_file :agatha_data, :url => "/assets/agatha_files/:id/:basename.:extension", :path => ":rails_root/public/assets/agatha_files/:id/:basename.:extension"
  USER_WHERE_STR = "";
  has_many :email_attachments, :class_name => "EmailAttachment", :dependent => :destroy
  
  belongs_to :person, :class_name => "Person", :foreign_key => "person_id"
  belongs_to :course, :class_name => "Course", :foreign_key => "course_id"
 
end
