class EmailAttachment < ActiveRecord::Base
      @@class_name ||= "EmailAttachment"
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
  belongs_to :agatha_email, :class_name => "AgathaEmail", :foreign_key => "agatha_email_id"
  belongs_to :agatha_file, :class_name => "AgathaFile", :foreign_key => "agatha_file_id"
end
