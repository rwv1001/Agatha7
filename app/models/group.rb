

class Group < ActiveRecord::Base
  @@class_name ||= "Group"
def class_name
  return @@class_name
end
def self.set_controller(search_controller_)
  @@search_controller = search_controller_
end

def search_controller
  return @@search_controller
end
  USER_WHERE_STR = "\"(a0.private = false OR a0.owner_id = \#{@user_id})\""

 
has_many :group_people, :class_name => "GroupPerson", :dependent => :destroy
has_many :group_lectures, :class_name => "GroupLecture", :dependent => :destroy
has_many :group_users, :class_name =>"GroupUser", :dependent => :destroy
has_many :group_agatha_emails, :class_name =>"GroupAgathaEmail", :dependent => :destroy
has_many :group_attendees, :class_name =>"GroupAttendee", :dependent => :destroy
has_many :group_courses, :class_name =>"GroupCourse", :dependent => :destroy
has_many :group_days, :class_name =>"GroupDay", :dependent => :destroy
has_many :group_email_templates, :class_name =>"GroupEmailTemplate", :dependent => :destroy
has_many :group_institutions, :class_name =>"GroupInstitution", :dependent => :destroy
has_many :group_locations, :class_name =>"GroupLocation", :dependent => :destroy
has_many :group_term, :class_name =>"GroupTerm", :dependent => :destroy
has_many :group_term_names, :class_name =>"GroupTermName", :dependent => :destroy
has_many :group_tutorials, :class_name =>"GroupTutorial", :dependent => :destroy
has_many :group_tutorial_schedules, :class_name =>"GroupTutorialSchedule", :dependent => :destroy
has_many :group_willing_lecturers, :class_name =>"GroupWillingLecturer", :dependent => :destroy
has_many :group_willing_tutors, :class_name =>"GroupWillingTutor", :dependent => :destroy


has_many :group_filters, :class_name => "GroupFilter", :dependent => :destroy

has_many :people, :class_name =>"Person", :through => :group_people
has_many :lectures, :class_name =>"Lecture", :through => :group_lectures
has_many :users, :class_name =>"User", :through => :group_users

belongs_to :owner,  :class_name => "User", :foreign_key => "owner_id"
belongs_to :readers_group,  :class_name => "GroupUser", :foreign_key => "readers_id"
belongs_to :writers_group, :class_name => "GroupUser", :foreign_key =>"writers_id"

  def group_list_strings  
   
    create_group_list 
  
    return @group_list_strings;
    
  end

  def group_list_ids
    
      create_group_list;
   
    return @group_list_ids;
  end
  
  private
  def create_group_list
    @group_list_strings = ['Select...'];
    @group_list_ids = [0];
    groups = Group.find(:all,:order => 'group_name asc');
    for group in groups
      @group_list_strings << group.group_name;
      @group_list_ids << group.id;
    end
    @group_list_defined = true;
  end

end
