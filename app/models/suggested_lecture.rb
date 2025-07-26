class SuggestedLecture
  attr_reader :search_ctl
  attr_reader :lecture
  attr_accessor :previous_suggestions;
  def initialize(search_ctl_, lecture_)
#    Rails.logger.error( "new SuggestedLecture" );
    @search_ctl = search_ctl_;
    @lecture = lecture_;
    @previous_suggestions=""
  end
  def self.default(search_ctl_)

    @previous_suggestions = "";
    default_lecture = Lecture.new;
    default_lecture.id = SearchController::NOT_SET;
    default_lecture.course_id = SearchController::NOT_SET;
    default_lecture.day_id = SearchController::NOT_SET;
    default_lecture.exam = "";
    default_lecture.location_id = SearchController::NOT_SET;
    default_lecture.lecture_time = "09:00"
    default_lecture.number_of_lectures = 0;
    default_lecture.number_of_classes = 0;
    default_lecture.person_id = SearchController::NOT_SET;
    default_lecture.term_id =SearchController::NOT_SET;
    lecture_search_controller = search_ctl_.search_ctls["Lecture"];
    ret_val = SuggestedLecture.new(lecture_search_controller, default_lecture);
    return ret_val;
  end
end