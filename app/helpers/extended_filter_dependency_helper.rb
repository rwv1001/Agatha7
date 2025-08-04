module ExtendedFilterDependencyHelper
  # Maps table names to their ExtendedFilter dependencies
  # This defines which tables need ExtendedFilter updates when a specific table changes
  EXTENDED_FILTER_DEPENDENCIES = {
    'Course' => ['Person'], # When courses change, update Person ExtendedFilters
    'Courses' => ['Person'], # Handle both singular and plural forms
    'Term' => ['Person'],   # When terms change, update Person ExtendedFilters  
    'Terms' => ['Person'],
    'TermName' => ['Person'], # When term_names change, update Person ExtendedFilters
    'TermNames' => ['Person'],
    'Group' => ['Person'],  # When groups change, update Person ExtendedFilters
    'Groups' => ['Person'],
    'Lecture' => ['Person'], # When lectures change, update Person ExtendedFilters
    'Lectures' => ['Person'],
    'TutorialSchedule' => ['Person'], # When tutorial_schedules change, update Person ExtendedFilters
    'TutorialSchedules' => ['Person'],
    'Tutorial' => ['Person'], # When tutorials change, update Person ExtendedFilters
    'Tutorials' => ['Person'],
    'Attendee' => ['Person'], # When attendees change, update Person ExtendedFilters
    'Attendees' => ['Person'],
    'GroupPerson' => ['Person'], # When group_people change, update Person ExtendedFilters
    'GroupPeople' => ['Person'],
    'Person' => ['Person'],  # When people change, update Person ExtendedFilters (for names in subqueries)
    'People' => ['Person']
  }.freeze

  # Maps ExtendedFilter names to the tables they depend on
  # This helps identify which specific filters need updating
  EXTENDED_FILTER_TABLE_DEPENDENCIES = {
    'Person' => {
      'groups_in' => ['Group', 'GroupPerson'],
      'lectures_attended_in_term' => ['Course', 'Lecture', 'Attendee', 'Term'],
      'lectures_attended' => ['Course', 'Lecture', 'Attendee', 'Term', 'TermName'],
      'tutorials_taken_in_term' => ['Course', 'TutorialSchedule', 'Tutorial', 'People', 'Term'],
      'tutorials_taken' => ['Course', 'TutorialSchedule', 'Tutorial', 'People', 'Term', 'TermName'],
      'collection_na' => ['Course', 'TutorialSchedule', 'Tutorial', 'People', 'Term', 'TermName'],
      'collection_na_term' => ['Course', 'TutorialSchedule', 'Tutorial', 'People', 'Term'],
      'collection_taken' => ['Course', 'TutorialSchedule', 'Tutorial', 'People', 'Term', 'TermName'],
      'collection_taken_term' => ['Course', 'TutorialSchedule', 'Tutorial', 'People', 'Term'],
      'collection_to_be_taken' => ['Course', 'TutorialSchedule', 'Tutorial', 'People', 'Term', 'TermName']
    }
  }.freeze

  def get_tables_needing_extended_filter_updates(edited_table_name)
    EXTENDED_FILTER_DEPENDENCIES[edited_table_name] || []
  end

  def get_affected_extended_filters(edited_table_name, target_table_name)
    return [] unless EXTENDED_FILTER_TABLE_DEPENDENCIES[target_table_name]
    
    affected_filters = []
    EXTENDED_FILTER_TABLE_DEPENDENCIES[target_table_name].each do |filter_name, dependencies|
      if dependencies.include?(edited_table_name)
        affected_filters << filter_name
      end
    end
    
    affected_filters
  end

  def should_update_extended_filters?(edited_table_name, target_table_name)
    tables_to_update = get_tables_needing_extended_filter_updates(edited_table_name)
    tables_to_update.include?(target_table_name)
  end
end
