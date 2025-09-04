class ModelDependencyService
  def self.get_affected_relationships_for_update(table_name, object_id, field_name)
    affected_relationships = []

    # Start with the updated object itself
    affected_relationships << {
      table: table_name,
      operation: "update",
      ids: [object_id.to_i],
      reason: "Direct update to #{field_name}"
    }

    case table_name
    when "Person"
      person = Person.find_by(id: object_id)
      return affected_relationships unless person

      # Person updates affect:
      # 1. Lectures where they are the lecturer
      lecture_ids = person.lecture_schedules.pluck(:id)
      if lecture_ids.any?
        affected_relationships << {
          table: "Lecture",
          operation: "update",
          ids: lecture_ids,
          reason: "Person #{object_id} is lecturer for these lectures"
        }
      end

      # 2. Lectures where they are an attendee
      attendee_lecture_ids = person.attendees.pluck(:lecture_id)
      if attendee_lecture_ids.any?
        affected_relationships << {
          table: "Lecture",
          operation: "update",
          ids: attendee_lecture_ids,
          reason: "Person #{object_id} attends these lectures"
        }
      end

      # 3. Tutorial schedules where they are the tutor
      tutorial_schedule_ids = person.tutorial_schedules.pluck(:id)
      if tutorial_schedule_ids.any?
        affected_relationships << {
          table: "TutorialSchedule",
          operation: "update",
          ids: tutorial_schedule_ids,
          reason: "Person #{object_id} is tutor for these tutorial schedules"
        }
      end

      # 4. Tutorials where they are the student
      tutorial_ids = person.tutorials.pluck(:id)
      if tutorial_ids.any?
        affected_relationships << {
          table: "Tutorial",
          operation: "update",
          ids: tutorial_ids,
          reason: "Person #{object_id} is student in these tutorials"
        }
      end

      # 5. Attendee records
      attendee_ids = person.attendees.pluck(:id)
      if attendee_ids.any?
        affected_relationships << {
          table: "Attendee",
          operation: "update",
          ids: attendee_ids,
          reason: "Person #{object_id} attendee records"
        }
      end

      # 6. Courses where they are a willing lecturer
      willing_lecturer_course_ids = WillingLecturer.where(person_id: object_id).pluck(:course_id)
      if willing_lecturer_course_ids.any?
        affected_relationships << {
          table: "Course",
          operation: "update",
          ids: willing_lecturer_course_ids,
          reason: "Person #{object_id} is willing lecturer for these courses"
        }
      end

      # 7. Courses where they are a willing tutor
      willing_tutor_course_ids = WillingTutor.where(person_id: object_id).pluck(:course_id)
      if willing_tutor_course_ids.any?
        affected_relationships << {
          table: "Course",
          operation: "update",
          ids: willing_tutor_course_ids,
          reason: "Person #{object_id} is willing tutor for these courses"
        }
      end

    when "Course"
      course = Course.find_by(id: object_id)
      return affected_relationships unless course

      # Course updates affect:
      # 1. Lectures for this course
      lecture_ids = course.lectures.pluck(:id)
      if lecture_ids.any?
        affected_relationships << {
          table: "Lecture",
          operation: "update",
          ids: lecture_ids,
          reason: "Course #{object_id} lectures"
        }
      end

      # 2. Tutorial schedules for this course
      tutorial_schedule_ids = course.tutorial_schedules.pluck(:id)
      if tutorial_schedule_ids.any?
        affected_relationships << {
          table: "TutorialSchedule",
          operation: "update",
          ids: tutorial_schedule_ids,
          reason: "Course #{object_id} tutorial schedules"
        }
      end

    when "Institution"
      institution = Institution.find_by(id: object_id)
      return affected_relationships unless institution

      # Institution updates affect people from that institution
      person_ids = Person.where(institution_id: object_id).pluck(:id)
      if person_ids.any?
        affected_relationships << {
          table: "Person",
          operation: "update",
          ids: person_ids,
          reason: "Institution #{object_id} members"
        }
      end

    when "Term"
      term = Term.find_by(id: object_id)
      return affected_relationships unless term

      # Term updates affect lectures and tutorial schedules in that term
      lecture_ids = Lecture.where(term_id: object_id).pluck(:id)
      if lecture_ids.any?
        affected_relationships << {
          table: "Lecture",
          operation: "update",
          ids: lecture_ids,
          reason: "Term #{object_id} lectures"
        }
      end

      tutorial_schedule_ids = TutorialSchedule.where(term_id: object_id).pluck(:id)
      if tutorial_schedule_ids.any?
        affected_relationships << {
          table: "TutorialSchedule",
          operation: "update",
          ids: tutorial_schedule_ids,
          reason: "Term #{object_id} tutorial schedules"
        }
      end

    when "Day"
      day = Day.find_by(id: object_id)
      return affected_relationships unless day

      # Day updates affect lectures on that day
      lecture_ids = Lecture.where(day_id: object_id).pluck(:id)
      if lecture_ids.any?
        affected_relationships << {
          table: "Lecture",
          operation: "update",
          ids: lecture_ids,
          reason: "Day #{object_id} lectures"
        }
      end

    when "Location"
      location = Location.find_by(id: object_id)
      return affected_relationships unless location

      # Location updates affect lectures at that location
      lecture_ids = Lecture.where(location_id: object_id).pluck(:id)
      if lecture_ids.any?
        affected_relationships << {
          table: "Lecture",
          operation: "update",
          ids: lecture_ids,
          reason: "Location #{object_id} lectures"
        }
      end

    when "Lecture"
      lecture = Lecture.find_by(id: object_id)
      return affected_relationships unless lecture

      # Lecture updates affect attendee records
      attendee_ids = lecture.attendees.pluck(:id)
      if attendee_ids.any?
        affected_relationships << {
          table: "Attendee",
          operation: "update",
          ids: attendee_ids,
          reason: "Lecture #{object_id} attendees"
        }
      end

    when "TutorialSchedule"
      tutorial_schedule = TutorialSchedule.find_by(id: object_id)
      return affected_relationships unless tutorial_schedule

      # Tutorial schedule updates affect tutorial records
      tutorial_ids = tutorial_schedule.tutorials.pluck(:id)
      if tutorial_ids.any?
        affected_relationships << {
          table: "Tutorial",
          operation: "update",
          ids: tutorial_ids,
          reason: "TutorialSchedule #{object_id} tutorials"
        }
      end

    when "WillingLecturer"
      willing_lecturer = WillingLecturer.find_by(id: object_id)
      return affected_relationships unless willing_lecturer

      # WillingLecturer updates affect the related course
      affected_relationships << {
        table: "Course",
        operation: "update",
        ids: [willing_lecturer.course_id],
        reason: "WillingLecturer #{object_id} affects course #{willing_lecturer.course_id}"
      }

    when "WillingTutor"
      willing_tutor = WillingTutor.find_by(id: object_id)
      return affected_relationships unless willing_tutor

      # WillingTutor updates affect the related course
      affected_relationships << {
        table: "Course",
        operation: "update",
        ids: [willing_tutor.course_id],
        reason: "WillingTutor #{object_id} affects course #{willing_tutor.course_id}"
      }
    end

    # Remove duplicate relationships and merge IDs
    consolidated_relationships = {}
    affected_relationships.each do |rel|
      key = "#{rel[:table]}_#{rel[:operation]}"
      if consolidated_relationships[key]
        consolidated_relationships[key][:ids] += rel[:ids]
        consolidated_relationships[key][:ids].uniq!
        consolidated_relationships[key][:reason] += "; #{rel[:reason]}"
      else
        consolidated_relationships[key] = rel.dup
      end
    end

    consolidated_relationships.values
  end

  def self.send_data_invalidation_for_update(table_name, object, field_name, object_id, uses_id)
    # Get all affected relationships for this update
    affected_relationships = get_affected_relationships_for_update(table_name, object_id, field_name)

    Rails.logger.info("=== Data Invalidation for #{table_name} Update ===")
    Rails.logger.info("Updated object: #{table_name} ID #{object_id}, field: #{field_name}")
    Rails.logger.info("Affected relationships (#{affected_relationships.length}):")

    affected_relationships.each_with_index do |rel, index|
      Rails.logger.info("  [#{index}] #{rel[:table]} #{rel[:operation]} (#{rel[:ids].length} records): #{rel[:reason]}")
      Rails.logger.info("      IDs: #{rel[:ids].inspect}")
    end

    # Broadcast the invalidation notification
    ActionCable.server.broadcast("search_table_updates", {
      action: "data_invalidation",
      triggered_by: {
        user_id: uses_id || 0,
        table: table_name,
        operation: "update",
        object_id: object_id.to_i,
        field_name: field_name
      },
      affected_relationships: affected_relationships,
      timestamp: Time.current.to_f
    })

    Rails.logger.info("Successfully broadcast data invalidation notification for #{table_name} update")
  rescue => e
    Rails.logger.error "ActionCable broadcast failed in ModelDependencyService.send_data_invalidation_for_update: #{e.message}"
    Rails.logger.error "Backtrace: #{e.backtrace.first(5).join('\n')}"
  end
end
