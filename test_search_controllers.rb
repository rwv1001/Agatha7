#!/usr/bin/env ruby

# Test script to verify SearchController functionality

# Simulate user session data
user_id = 1
administrator = true

puts "Testing SearchController initialization..."

# Create search controllers for all table types like in WelcomeController
table_options = ["Person","Attendee","GroupPerson","GroupLecture","GroupCourse","GroupAttendee", "GroupTutorial","GroupTutorialSchedule", "GroupInstitution", "GroupUser","GroupTerm","GroupDay","GroupLocation","GroupWillingLecturer","GroupWillingTutor","Lecture","TutorialSchedule","Tutorial","WillingTeacher","WillingLecturer","WillingTutor","EmailTemplate","AgathaEmail", "GroupEmailTemplate","GroupAgathaEmail","Course","Group","Location","Institution","Term","TermName","Day", "User", "MaximumTutorial", "AgathaFile", "EmailAttachment"]

search_ctls = {}

puts "Creating SearchController objects for #{table_options.length} table types..."

for table_name in table_options
  begin
    search_controller = SearchController.new(table_name, user_id, administrator, {})
    search_ctls[table_name] = search_controller
    puts "  Created SearchController for #{table_name}"
  rescue => e
    puts "  ERROR creating SearchController for #{table_name}: #{e.message}"
  end
end

puts "Created search_ctls hash with #{search_ctls.keys.length} controllers"

# Test SetExtendedFilterControllers for each controller
puts "Testing SetExtendedFilterControllers..."
for table_name, search_controller in search_ctls
  begin
    search_controller.SetExtendedFilterControllers(search_ctls)
    puts "  SetExtendedFilterControllers completed for #{table_name}"
  rescue => e
    puts "  ERROR in SetExtendedFilterControllers for #{table_name}: #{e.message}"
  end
end

# Test FilterController access on Person controller
table_name = "Person"
search_controller = search_ctls[table_name]
puts "Testing FilterController for #{table_name}..."
filter_controller = search_controller.filter_controller

if filter_controller
  puts "FilterController is available"
  
  # Test GetOptions method with Term (which should now be available)
  puts "Testing GetOptions method..."
  begin
    # This should not fail with GetAllShortFieldsWhere error
    options = filter_controller.GetOptions("term", "Term", 1, true, false)
    puts "GetOptions completed successfully, returned #{options.length} options"
  rescue => e
    puts "ERROR in GetOptions: #{e.message}"
    puts e.backtrace[0..5]
  end
else
  puts "ERROR: FilterController is nil"
end

puts "Test completed"
