class TestController < ApplicationController
  skip_before_action :authorize

  def search_init
    # Initialize search controllers like WelcomeController does
    user_id = 1
    administrator = true
    
    # Create fresh search controllers
    table_options = ["Person","Attendee","GroupPerson","GroupLecture","GroupCourse","GroupAttendee", "GroupTutorial","GroupTutorialSchedule", "GroupInstitution", "GroupUser","GroupTerm","GroupDay","GroupLocation","GroupWillingLecturer","GroupWillingTutor","Lecture","TutorialSchedule","Tutorial","WillingTeacher","WillingLecturer","WillingTutor","EmailTemplate","AgathaEmail", "GroupEmailTemplate","GroupAgathaEmail","Course","Group","Location","Institution","Term","TermName","Day", "User", "MaximumTutorial", "AgathaFile", "EmailAttachment"]

    @search_ctls = {}
    
    logger.info "Creating #{table_options.length} search controllers..."
    
    table_options.each do |table_name|
      begin
        search_controller = SearchController.new(table_name, user_id, administrator, session)
        @search_ctls[table_name] = search_controller
        logger.debug "Created SearchController for #{table_name}"
      rescue => e
        logger.error "ERROR creating SearchController for #{table_name}: #{e.message}"
      end
    end
    
    logger.info "Created #{@search_ctls.keys.length} search controllers"
    
    # Call SetExtendedFilterControllers
    @search_ctls.each do |table_name, search_controller|
      begin
        search_controller.SetExtendedFilterControllers(@search_ctls)
        logger.debug "SetExtendedFilterControllers completed for #{table_name}"
      rescue => e
        logger.error "ERROR in SetExtendedFilterControllers for #{table_name}: #{e.message}"
      end
    end
    
    # Test FilterController functionality
    person_controller = @search_ctls["Person"]
    if person_controller && person_controller.filter_controller
      begin
        options = person_controller.filter_controller.GetOptions("term", "Term", 1, true, false)
        logger.info "GetOptions test successful: returned #{options.length} options"
        
        # Test SuggestedLecture functionality
        course_controller = @search_ctls["Course"]
        if course_controller
          suggested_lecture = SuggestedLecture.default(course_controller)
          logger.info "SuggestedLecture test successful: #{suggested_lecture.class}"
          
          # Test SuggestedTutorial functionality
          suggested_tutorial = SuggestedTutorial.default(course_controller)
          logger.info "SuggestedTutorial test successful: #{suggested_tutorial.class}"
          
          render json: { 
            success: true, 
            message: "Search controllers initialized successfully", 
            options_count: options.length,
            suggested_lecture_test: "passed",
            suggested_tutorial_test: "passed"
          }
        else
          render json: { success: false, error: "Course controller is nil" }
        end
      rescue => e
        logger.error "ERROR in tests: #{e.message}"
        logger.error e.backtrace[0..5]
        render json: { success: false, error: e.message }
      end
    else
      render json: { success: false, error: "Person controller or filter_controller is nil" }
    end
  end
end
