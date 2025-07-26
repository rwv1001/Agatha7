class EmailTemplate < ActiveRecord::Base
  @@class_name ||= "EmailTemplate"
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

      has_many :group_email_templates, :class_name => "GroupEmailTemplate", :dependent => :destroy
      has_many :agatha_emails, :class_name => "AgathaEmail", :dependent => :destroy

end
