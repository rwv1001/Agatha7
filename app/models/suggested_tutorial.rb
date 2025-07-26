class SuggestedTutorial
  attr_reader :search_ctl
  attr_reader :tutorial_schedule
  attr_accessor :previous_suggestions;
  def initialize(search_ctl_, tutorial_schedule_)
    # Rails.logger.error( "new SuggestedTutorial" );
    @search_ctl = search_ctl_;
    @tutorial_schedule = tutorial_schedule_;
    @previous_suggestions=""
  end
  def self.default(search_ctl_)

    @previous_suggestions = "";
    default_tutorial_schedule = TutorialSchedule.new;
    default_tutorial_schedule.id = SearchController::NOT_SET;
    default_tutorial_schedule.course_id = SearchController::NOT_SET;
    default_tutorial_schedule.number_of_tutorials = 0;
    default_tutorial_schedule.number_of_tutorial_hours = 0;
    default_tutorial_schedule.person_id = SearchController::NOT_SET;
    default_tutorial_schedule.term_id =SearchController::NOT_SET;
    tutorial_schedule_search_controller = search_ctl_.search_ctls["TutorialSchedule"];
    ret_val = SuggestedTutorial.new(tutorial_schedule_search_controller, default_tutorial_schedule);
    return ret_val;
  end
end
