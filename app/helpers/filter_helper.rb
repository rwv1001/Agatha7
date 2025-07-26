module FilterHelper
  def create_external_filters(session)
    extended_filters = {};
    extended_filters["AgathaFile"]=[
       ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaFile", #class_name
      "Files for courses lectured in term", #header
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.course_id = a0.course_id AND b1.term_id = arg_value)>0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaFile", #class_name
      "Files for courses tutored in term", #header
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.course_id = a0.course_id AND b1.term_id = arg_value)>0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaFile", #class_name
      "Files for courses lectured to person", #header
      "(SELECT COUNT(*) FROM attendees b1 INNER JOIN lectures b2 ON b2.id = b1.lecture_id WHERE b2.course_id = a0.course_id AND b1.person_id = arg_value)>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaFile", #class_name
      "Files for courses tutored to person", #header
      "(SELECT COUNT(*) FROM tutorials b1 INNER JOIN tutorial_schedules b2 ON b2.id = b1.tutorial_schedule_id WHERE b2.course_id = a0.course_id AND b1.person_id = arg_value)>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaFile", #class_name
      "Lecture files relevant to email", #header
      "(SELECT COUNT(*) FROM agatha_emails b1 WHERE b1.id = arg_value AND (SELECT COUNT(*) FROM attendees b2 INNER JOIN lectures b3 ON b3.id = b2.lecture_id WHERE b2.person_id = b1.person_id AND b3.course_id = a0.course_id AND b3.term_id = b1.term_id)>0)>0", #where_str_
      "AgathaEmail",#argument_class_
      "GroupAgathaEmail",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaFile", #class_name
      "Lecture files relevant to email year", #header
      "(SELECT COUNT(*) FROM agatha_emails b1 WHERE b1.id = arg_value AND (SELECT COUNT(*) FROM attendees b2 INNER JOIN lectures b3 ON b3.id = b2.lecture_id WHERE b2.person_id = b1.person_id AND b3.course_id = a0.course_id AND b3.term_id IN (b1.term_id, b1.term_id+1, b1.term_id+2))>0)>0", #where_str_
      "AgathaEmail",#argument_class_
      "GroupAgathaEmail",#group_class_
       "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaFile", #class_name
      "Tutorial files relevant to email", #header
      "(SELECT COUNT(*) FROM agatha_emails b1 WHERE b1.id = arg_value AND (SELECT COUNT(*) FROM tutorials b2 INNER JOIN tutorial_schedules b3 ON b3.id = b2.tutorial_schedule_id WHERE b2.person_id = b1.person_id AND b3.course_id = a0.course_id AND b3.term_id = b1.term_id)>0)>0", #where_str_
      "AgathaEmail",#argument_class_
      "GroupAgathaEmail",#group_class_
       "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaFile", #class_name
      "Tutorial files relevant to email year", #header
      "(SELECT COUNT(*) FROM agatha_emails b1 WHERE b1.id = arg_value AND (SELECT COUNT(*) FROM tutorials b2 INNER JOIN tutorial_schedules b3 ON b3.id = b2.tutorial_schedule_id WHERE b2.person_id = b1.person_id AND b3.course_id = a0.course_id AND b3.term_id IN (b1.term_id, b1.term_id+1, b1.term_id+2))>0)>0", #where_str_
      "AgathaEmail",#argument_class_
      "GroupAgathaEmail",#group_class_
       "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      ))
    ]
    extended_filters["AgathaEmail"]=[
       ExtendedFilter.new(:subquery, SubQuery.new([],"Email attachments", "agatha_email_attachments" ,
      %q{array_to_string(ARRAY(SELECT '<a class=attachment_links target=_blank href=\#{AgathaFile.find(' || b2.id || ').agatha_data.url}>'|| b2.agatha_data_file_name || '</a>'  FROM email_attachments b1 INNER JOIN agatha_files b2 ON b2.id = b1.agatha_file_id WHERE b1.agatha_email_id = a0.id ORDER BY b2.agatha_data_file_name ASC), '<br>')}, "")),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaEmail", #class_name
      "Emails in group", #header
      "(SELECT COUNT(*) FROM group_agatha_emails b1 WHERE b1.group_id = arg_value AND b1.agatha_email_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='agatha_emails' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaEmail", #class_name
      "Emails not in group", #header
      "(SELECT COUNT(*) FROM group_agatha_emails b1 WHERE b1.group_id = arg_value AND b1.agatha_email_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='agatha_emails' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaEmail", #class_name
      "Emails for recipient", #header
      "(a0.person_id = arg_value)", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      false,#allow_multiple_arguments
      true#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaEmail", #class_name
      "Emails for recipients in group", #header
      "(SELECT COUNT(*) FROM group_people b1 WHERE b1.group_id = arg_value AND b1.person_id = a0.person_id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='people' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaEmail", #class_name
      "Emails for recipients not in group", #header
      "(SELECT COUNT(*) FROM group_people b1 WHERE b1.group_id = arg_value AND b1.person_id = a0.person_id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='people' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaEmail", #class_name
      "Emails created for term", #header
      "(a0.term_id = arg_value)", #where_str_
      "Term",#argument_class_
      "GroupTerm",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      false,#allow_multiple_arguments
      true#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaEmail", #class_name
      "Emails created from template", #header
      "(a0.email_template_id = arg_value)", #where_str_
      "EmailTemplate",#argument_class_
      "GroupEmailTemplate",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      false,#allow_multiple_arguments
      true#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaEmail", #class_name
      "Emails created from templates in group", #header
      "(SELECT COUNT(*) FROM group_email_templates b1 WHERE b1.group_id = arg_value AND b1.email_template_id = a0.email_template_id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='email_templates' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaEmail", #class_name
      "Emails created from templates not in group", #header
      "(SELECT COUNT(*) FROM group_email_templates b1 WHERE b1.group_id = arg_value AND b1.email_template_id = a0.email_template_id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='email_templates' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaEmail", #class_name                                                               
      "Emails for recipient attending lecture", #header
      "(SELECT COUNT(*) FROM attendees b1 WHERE b1.person_id = a0.person_id AND b1.lecture_id = arg_value)>0", #where_str_
      "Lecture",#argument_class_
      "GroupLecture",#group_class_
       "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaEmail", #class_name
      "Emails for recipients attending lectures in email year", #header
      "(SELECT COUNT(*) FROM attendees b1 INNER JOIN lectures b2 ON b2.id = b1.lecture_id  WHERE b1.person_id = a0.person_id AND b2.course_id = arg_value AND b2.term_id IN (a0.term_id, a0.term_id+1, a0.term_id+2))>0", #where_str_
      "Course",#argument_class_
      "GroupCourse",#group_class_
       "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaEmail", #class_name
      "Emails for recipients attending tutorials in email term", #header
      "(SELECT COUNT(*) FROM tutorials b1 INNER JOIN tutorial_schedules b2 ON b2.id = b1.tutorial_schedule_id  WHERE b1.person_id = a0.person_id AND b2.course_id = arg_value AND b2.term_id = a0.term_id)>0", #where_str_
      "Course",#argument_class_
      "GroupCourse",#group_class_
       "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaEmail", #class_name
      "Emails for recipients attending tutorials in email year", #header
      "(SELECT COUNT(*) FROM tutorials b1 INNER JOIN tutorial_schedules b2 ON b2.id = b1.tutorial_schedule_id  WHERE b1.person_id = a0.person_id AND b2.course_id = arg_value AND b2.term_id IN (a0.term_id, a0.term_id+1, a0.term_id+2))>0", #where_str_
      "Course",#argument_class_
      "GroupCourse",#group_class_
       "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaEmail", #class_name
      "Emails for recipients tutored by person in email term", #header
      "(SELECT COUNT(*) FROM tutorials b1 INNER JOIN tutorial_schedules b2 ON b2.id = b1.tutorial_schedule_id  WHERE b1.person_id = a0.person_id AND b2.person_id = arg_value AND b2.term_id = a0.term_id)>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
       "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("AgathaEmail", #class_name
      "Emails for recipients tutored by person in email year", #header
      "(SELECT COUNT(*) FROM tutorials b1 INNER JOIN tutorial_schedules b2 ON b2.id = b1.tutorial_schedule_id  WHERE b1.person_id = a0.person_id AND b2.person_id = arg_value AND b2.term_id IN (a0.term_id, a0.term_id+1, a0.term_id+2))>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
       "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      ))
    ]
    extended_filters["Attendee"]=[
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Attendee", #class_name
      "Attendees in group", #header
      "(SELECT COUNT(*) FROM group_attendees b1 WHERE b1.group_id = arg_value AND b1.attendee_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='attendees' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
          ExtendedFilter.new(:external_filter, ExternalFilter.new("Attendee", #class_name
      "Attendees in group", #header
      "(SELECT COUNT(*) FROM group_attendees b1 WHERE b1.group_id = arg_value AND b1.attendee_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='attendees' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
           ExtendedFilter.new(:external_filter, ExternalFilter.new("Attendee", #class_name
      "Attendees in some group", #header
      "(SELECT COUNT(*) FROM group_attendees b1 WHERE b1.attendee_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
           ExtendedFilter.new(:external_filter, ExternalFilter.new("Attendee", #class_name
      "Attendees not in any group", #header
      "(SELECT COUNT(*) FROM group_attendees b1 WHERE b1.attendee_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
    ExtendedFilter.new(:external_filter, ExternalFilter.new("Attendee", #class_name
      "Attendee person", #header
      "(a0.person_id = arg_value)", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      false,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Attendee", #class_name
      "Attendee who is not person", #header
      "(a0.person_id != arg_value)", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Attendee", #class_name
      "Lectured by person", #header
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.person_id = arg_value AND a0.lecture_id = b1.id )>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      false,#allow_multiple_arguments
      true#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Attendee", #class_name
      "Not lectured by person", #header
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.person_id = arg_value AND a0.lecture_id = b1.id )=0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      false,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Attendee", #class_name
      "Given in term", #header
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.term_id = arg_value AND a0.lecture_id = b1.id )>0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Attendee", #class_name
      "Not given in term", #header
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.term_id = arg_value AND a0.lecture_id = b1.id )=0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      ))
  ];
    extended_filters["Course"]=[
  ExtendedFilter.new(:subquery, SubQuery.new([],"Groups in", "groups_in" ,
      "array_to_string(ARRAY(SELECT CASE b1.group_id WHEN 1 THEN 'Not Set' ELSE b2.group_name END AS b1_group_id FROM group_courses b1 INNER JOIN groups b2 ON b1.group_id = b2.id WHERE b1.course_id = a0.id ORDER BY b1_group_id asc),';<br>')", "")),
  ExtendedFilter.new(:subquery, SubQuery.new(["Person","Lecture"],"Lecturers of", "lecturers_of" ,
      "array_to_string(ARRAY(SELECT b1.first_name || ' ' || b1.second_name || ', ' || SUBSTRING(b5.name,1,1) || SUBSTRING('' || b4.year,3,2) FROM people b1 INNER JOIN ( lectures b2 INNER JOIN ( terms b4 INNER JOIN term_names b5 ON b4.term_name_id = b5.id ) ON b2.term_id = b4.id) ON b2.person_id = b1.id  WHERE b2.course_id = a0.id ORDER BY b1.first_name),',<br>')", "")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Tutors of", "tutors_of" ,
      "array_to_string(ARRAY(SELECT b1.first_name || ' ' || b1.second_name || ', ' || SUBSTRING(b5.name,1,1) || SUBSTRING('' || b4.year,3,2) FROM people b1 INNER JOIN ( tutorial_schedules b2 INNER JOIN ( terms b4 INNER JOIN term_names b5 ON b4.term_name_id = b5.id ) ON b2.term_id = b4.id) ON b2.person_id = b1.id  WHERE b2.course_id = a0.id ORDER BY b1.first_name),',<br>')", "")),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses in group", #header
      "(SELECT COUNT(*) FROM group_courses b1 WHERE b1.group_id = arg_value AND b1.course_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='courses' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses not in group", #header
      "(SELECT COUNT(*) FROM group_courses b1 WHERE b1.group_id = arg_value AND b1.course_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='courses' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses in some group", #header
      "(SELECT COUNT(*) FROM group_courses b1 WHERE b1.course_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
           ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses not in any group", #header
      "(SELECT COUNT(*) FROM group_courses b1 WHERE b1.course_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses having lecture schedule", #header
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.course_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses not having lecture schedule", #header
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.course_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses having tutorial schedule", #header
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.course_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses not having tutorial schedule", #header
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.course_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses lectured to person", #header
      "(SELECT COUNT(*) FROM attendees b1 INNER JOIN lectures b2 ON b2.id = b1.lecture_id WHERE b1.person_id = arg_value AND b2.course_id = a0.id)>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses not lectured to person", #header
      "(SELECT COUNT(*) FROM attendees b1 INNER JOIN lectures b2 ON b2.id = b1.lecture_id WHERE b1.person_id = arg_value AND b2.course_id = a0.id)=0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses tutored to person", #header
      "(SELECT COUNT(*) FROM tutorials b1 INNER JOIN tutorial_schedules b2 ON b2.id = b1.tutorial_schedule_id WHERE b1.person_id = arg_value AND b2.course_id = a0.id)>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses not tutored to person", #header
      "(SELECT COUNT(*) FROM tutorials b1 INNER JOIN tutorial_schedules b2 ON b2.id = b1.tutorial_schedule_id WHERE b1.person_id = arg_value AND b2.course_id = a0.id)=0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
    ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses lectured by person", #header
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.person_id = arg_value AND b1.course_id = a0.id)>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
    ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses not lectured by person", #header
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.person_id = arg_value AND b1.course_id = a0.id)=0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
    ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses tutored by person", #header
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.person_id = arg_value AND b1.course_id = a0.id)>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
        ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses not tutored by person", #header
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.person_id = arg_value AND b1.course_id = a0.id)=0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
     ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses lectured in term", #header
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.term_id = arg_value AND b1.course_id = a0.id)>0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
     ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses not lectured in term", #header
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.term_id = arg_value AND b1.course_id = a0.id)=0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses tutored in term", #header
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.term_id = arg_value AND b1.course_id = a0.id)>0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Course", #class_name
      "Courses not tutored in term", #header
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.term_id = arg_value AND b1.course_id = a0.id)=0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      ))
  ];
    extended_filters["Day"]=[]
    extended_filters["EmailTemplate"]=[
      ExtendedFilter.new(:external_filter, ExternalFilter.new("EmailTemplate", #class_name
      "Email templates in group", #header
      "(SELECT COUNT(*) FROM group_email_templates b1 WHERE b1.email_template_id = a0.id AND b1.group_id = arg_value)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='email_templates' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("EmailTemplate", #class_name
      "Email templates not in group", #header
      "(SELECT COUNT(*) FROM group_email_templates b1 WHERE b1.email_template_id = a0.id AND b1.group_id = arg_value)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='email_templates' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      ))
    ]        
    extended_filters["Group"]=[
        ExtendedFilter.new(:subquery, SubQuery.new([],"Number of group members", "number_of_group_members" ,
      "(CASE a0.table_name
        WHEN 'people' THEN (SELECT COUNT(*) FROM group_people x1 WHERE x1.group_id = a0.id)
        WHEN 'courses' THEN (SELECT COUNT(*) FROM group_courses x1 WHERE x1.group_id = a0.id)
        WHEN 'days' THEN (SELECT COUNT(*) FROM group_days x1 WHERE x1.group_id = a0.id)
        WHEN 'institutions' THEN (SELECT COUNT(*) FROM group_institutions x1 WHERE x1.group_id = a0.id)
        WHEN 'lectures' THEN (SELECT COUNT(*) FROM group_lectures x1 WHERE x1.group_id = a0.id)
        WHEN 'attendees' THEN (SELECT COUNT(*) FROM group_attendees x1 WHERE x1.group_id = a0.id)
        WHEN 'locations' THEN (SELECT COUNT(*) FROM group_locations x1 WHERE x1.group_id = a0.id)
        WHEN 'programmes' THEN (SELECT COUNT(*) FROM group_programmes x1 WHERE x1.group_id = a0.id)
        WHEN 'tutorial_schedules' THEN (SELECT COUNT(*) FROM group_tutorial_schedules x1 WHERE x1.group_id = a0.id)
        WHEN 'tutorials' THEN (SELECT COUNT(*) FROM group_tutorials x1 WHERE x1.group_id = a0.id)
        WHEN 'users' THEN (SELECT COUNT(*) FROM group_users x1 WHERE x1.group_id = a0.id)
        WHEN 'agatha_emails' THEN (SELECT COUNT(*) FROM group_agatha_emails x1 WHERE x1.group_id = a0.id)
        WHEN 'email_templates' THEN (SELECT COUNT(*) FROM group_email_templates x1 WHERE x1.group_id = a0.id)
        WHEN 'willing_tutors' THEN (SELECT COUNT(*) FROM group_willing_tutors x1 WHERE x1.group_id = a0.id)
        WHEN 'willing_lecturers' THEN (SELECT COUNT(*) FROM group_willing_lecturers x1 WHERE x1.group_id = a0.id)
        ELSE 0 END)", "")),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Group", #class_name
      "Groups of type", #header
      "a0.table_name = 'arg_value'", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[GroupMember.new(\"People\",\"people\"),
       GroupMember.new(\"Courses\",\"courses\"),
       GroupMember.new(\"Institutions\",\"institutions\"),
       GroupMember.new(\"Lectures\",\"lectures\"),
       GroupMember.new(\"Attendees\",\"attendees\"),
       GroupMember.new(\"Tutorials\",\"tutorials\"),
       GroupMember.new(\"Tutorial Schedules\",\"tutorial_schedules\"),
       GroupMember.new(\"Willing Lecturers\",\"willing_lecturers\"),
       GroupMember.new(\"Locations\",\"locations\"),                                                       
       GroupMember.new(\"Willing Tutors\",\"willing_tutors\"),
       GroupMember.new(\"Users\",\"users\"),
       GroupMember.new(\"AgathaEmails\",\"agatha_emails\"),
       GroupMember.new(\"Email Templates\",\"email_templates\")]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Group", #class_name
      "Groups having person", #header
      "(SELECT COUNT(*) FROM group_people b1 WHERE b1.person_id = arg_value AND b1.group_id = a0.id)>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Group", #class_name
      "Groups not having person", #header
      "(a0.table_name = 'people' AND (SELECT COUNT(*) FROM group_people b1 WHERE b1.person_id = arg_value AND b1.group_id = a0.id)=0)", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Group", #class_name
      "Groups having course", #header
      "(SELECT COUNT(*) FROM group_courses b1 WHERE b1.course_id = arg_value AND b1.group_id = a0.id)>0", #where_str_
      "Course",#argument_class_
      "GroupCourse",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Group", #class_name
      "Groups not having course", #header
      "(a0.table_name = 'courses' AND (SELECT COUNT(*) FROM group_courses b1 WHERE b1.course_id = arg_value AND b1.group_id = a0.id)=0)", #where_str_
      "Course",#argument_class_
      "GroupCourse",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
           ExtendedFilter.new(:external_filter, ExternalFilter.new("Group", #class_name
      "Groups having lecture", #header
      "(SELECT COUNT(*) FROM group_lectures b1 WHERE b1.lecture_id = arg_value AND b1.group_id = a0.id)>0", #where_str_
      "Lecture",#argument_class_
      "GroupLecture",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Group", #class_name
      "Groups not having lecture", #header
      "(a0.table_name = 'lectures' AND (SELECT COUNT(*) FROM group_lectures b1 WHERE b1.lecture_id = arg_value AND b1.group_id = a0.id)=0)", #where_str_
      "Lecture",#argument_class_
      "GroupLecture",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Group", #class_name
      "Groups having tutorial schedule", #header
      "(SELECT COUNT(*) FROM group_tutorial_schedules b1 WHERE b1.tutorial_schedule_id = arg_value AND b1.group_id = a0.id)>0", #where_str_
      "TutorialSchedule",#argument_class_
      "GroupTutorialSchedule",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Group", #class_name
      "Groups not having lecture", #header
      "(a0.table_name = 'tutorial_schedules' AND (SELECT COUNT(*) FROM group_tutorial_schedules b1 WHERE b1.tutorial_schedule_id = arg_value AND b1.group_id = a0.id)=0)", #where_str_
      "TutorialSchedule",#argument_class_
      "GroupTutorialSchedule",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      ))
  ];
    extended_filters["GroupAgathaEmail"]=[]
    extended_filters["GroupAttendee"]=[]
    extended_filters["GroupCourse"]=[]
    extended_filters["GroupDay"]=[]
    extended_filters["GroupEmailTemplate"]=[]
    extended_filters["GroupInstitution"]=[]
    extended_filters["GroupLecture"]=[]
    extended_filters["GroupLocation"]=[]
    extended_filters["GroupPerson"]=[]
    extended_filters["GroupTerm"]=[]
    extended_filters["GroupTutorial"]=[]
    extended_filters["GroupTutorialSchedule"]=[]
    extended_filters["GroupUser"]=[]
    extended_filters["GroupWillingLecturer"]=[]
    extended_filters["GroupWillingTutor"]=[]
    
    extended_filters["EmailAttachment"]=[]

    extended_filters["Institution"]=[
     ExtendedFilter.new(:external_filter, ExternalFilter.new("Institution", #class_name
      "Institutions in group", #header
      "(SELECT COUNT(*) FROM group_institutions b1 WHERE b1.institution_id = a0.id AND b1.group_id = arg_value)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='institutions' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Institution", #class_name
      "Institutions not in group", #header
      "(SELECT COUNT(*) FROM group_institutions b1 WHERE b1.institution_id = a0.id AND b1.group_id = arg_value)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='institutions' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_

    )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Institution", #class_name
      "Institutions in some group", #header
      "(SELECT COUNT(*) FROM group_institutions b1 WHERE b1.institution_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
           ExtendedFilter.new(:external_filter, ExternalFilter.new("Institution", #class_name
      "Institutions not in any group", #header
      "(SELECT COUNT(*) FROM group_institutions b1 WHERE b1.institution_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      ))
  ];
    extended_filters["Lecture"]=[
      ExtendedFilter.new(:subquery, SubQuery.new([],"Number of students at lecture", "number_of_students_at_lecture" ,
      "(SELECT COUNT(*) FROM attendees b1 WHERE b1.lecture_id = a0.id)", "")),
       ExtendedFilter.new(:subquery, SubQuery.new([],"Students at lecture", "students_at_lecture" ,
      "array_to_string(ARRAY(SELECT  b1.first_name || ' ' || b1.second_name FROM people b1 INNER JOIN  attendees b2 ON b2.person_id = b1.id WHERE b2.lecture_id = a0.id ORDER BY b1.first_name),',<br> ')", "")),
   ExtendedFilter.new(:subquery, SubQuery.new([],"Students examined", "students_examined" ,
      "array_to_string(ARRAY(SELECT  b1.first_name || ' ' || b1.second_name FROM people b1 INNER JOIN  attendees b2 ON b2.person_id = b1.id WHERE b2.lecture_id = a0.id AND b2.examined=true ORDER BY b1.first_name),',<br> ')", "")),
   ExtendedFilter.new(:subquery, SubQuery.new([],"Compulsory students", "compulsory_students" ,
      "array_to_string(ARRAY(SELECT  b1.first_name || ' ' || b1.second_name FROM people b1 INNER JOIN  attendees b2 ON b2.person_id = b1.id WHERE b2.lecture_id = a0.id AND b2.compulsory=true ORDER BY b1.first_name),',<br> ')", "")),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Lecture", #class_name
      "Lectures in group", #header
      "(SELECT COUNT(*) FROM group_lectures b1 WHERE b1.group_id = arg_value AND b1.lecture_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='lectures' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Lecture", #class_name
      "Lectures not in group", #header
      "(SELECT COUNT(*) FROM group_lectures b1 WHERE b1.group_id = arg_value AND b1.lecture_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='lectures' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
           ExtendedFilter.new(:external_filter, ExternalFilter.new("Lecture", #class_name
      "Lectures in some group", #header
      "(SELECT COUNT(*) FROM group_lectures b1 WHERE b1.lecture_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
           ExtendedFilter.new(:external_filter, ExternalFilter.new("Lecture", #class_name
      "Lectures not in any group", #header
      "(SELECT COUNT(*) FROM group_lectures b1 WHERE b1.lecture_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Lecture", #class_name
      "Lectures attended by person", #header
      "(SELECT COUNT(*) FROM attendees b1 WHERE b1.person_id = arg_value AND b1.lecture_id = a0.id)>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Lecture", #class_name
      "Lectures not attended by person", #header
      "(SELECT COUNT(*) FROM attendees b1 WHERE b1.person_id = arg_value AND b1.lecture_id = a0.id)=0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Lecture", #class_name
      "Lectures taught by person", #header
      "(a0.person_id = arg_value)", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Lecture", #class_name
      "Lectures not taught by person", #header
      "(a0.person_id != arg_value)", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Lecture", #class_name
      "Lectures taught in term", #header
      "(a0.term_id = arg_value)", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Lecture", #class_name
      "Lectures not taught in term", #header
      "(a0.term_id != arg_value)", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      ))
];
    extended_filters["Location"]=[        
     ExtendedFilter.new(:external_filter, ExternalFilter.new("Location", #class_name
      "Locations in group", #header
      "(SELECT COUNT(*) FROM group_locations b1 WHERE b1.location_id = a0.id AND b1.group_id = arg_value)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='locations' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Location", #class_name
      "Locations not in group", #header
      "(SELECT COUNT(*) FROM group_locations b1 WHERE b1.location_id = a0.id AND b1.group_id = arg_value)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='locations' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_

    )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Location", #class_name
      "Locations in some group", #header
      "(SELECT COUNT(*) FROM group_locations b1 WHERE b1.location_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
           ExtendedFilter.new(:external_filter, ExternalFilter.new("Location", #class_name
      "Locations not in any group", #header
      "(SELECT COUNT(*) FROM group_locations b1 WHERE b1.location_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      ))
];
    extended_filters["MaximumTutorial"]=[];
    extended_filters["Term"]=[];
    extended_filters["TermName"]=[];
    extended_filters["Tutorial"]=[
      ExtendedFilter.new(:foreign_filter, ForeignFilter.new("tutorial_schedule_id","person_id")),
       ExtendedFilter.new(:foreign_filter, ForeignFilter.new("tutorial_schedule_id","course_id")),
        ExtendedFilter.new(:foreign_filter, ForeignFilter.new("tutorial_schedule_id","term_id")),
      ExtendedFilter.new(:foreign_filter, ForeignFilter.new("tutorial_schedule_id","number_of_tutorials")),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Tutorial", #class_name
      "Tutorials in group", #header
      "(SELECT COUNT(*) FROM group_tutorials b1 WHERE b1.group_id = arg_value AND b1.tutorial_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='tutorials' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Tutorial", #class_name
      "Tutorials not in group", #header
      "(SELECT COUNT(*) FROM group_tutorials b1 WHERE b1.group_id = arg_value AND b1.tutorial_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='tutorials' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
           ExtendedFilter.new(:external_filter, ExternalFilter.new("Tutorial", #class_name
      "Tutorials in some group", #header
      "(SELECT COUNT(*) FROM group_tutorials b1 WHERE b1.tutorial_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
           ExtendedFilter.new(:external_filter, ExternalFilter.new("Tutorial", #class_name
      "Tutorials not in any group", #header
      "(SELECT COUNT(*) FROM group_tutorials b1 WHERE b1.tutorial_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Tutorial", #class_name
      "Tutorials for student", #header
      "(a0.person_id = arg_value)", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      false,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Tutorial", #class_name
      "Tutorials for not student", #header
      "(a0.person_id != arg_value)", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Tutorial", #class_name
      "Tutorials given by tutor", #header
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.person_id = arg_value AND a0.tutorial_schedule_id = b1.id )>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      false,#allow_multiple_arguments
      true#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Tutorial", #class_name
      "Tutorials not given by tutor", #header
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.person_id = arg_value AND a0.tutorial_schedule_id = b1.id )=0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      false,#allow_multiple_arguments
      true#group_selector_
      )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("Tutorial", #class_name
      "Tutorials given in term", #header
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.term_id = arg_value AND a0.tutorial_schedule_id = b1.id )>0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Tutorial", #class_name
      "Tutorials not given in term", #header
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.term_id = arg_value AND a0.tutorial_schedule_id = b1.id )=0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      ))
  ];
    extended_filters["TutorialSchedule"]=[
      ExtendedFilter.new(:subquery, SubQuery.new([],"Students tutored", "students_tutored" ,
      "array_to_string(ARRAY(SELECT  b1.first_name || ' ' || b1.second_name FROM people b1 INNER JOIN  tutorials b2 ON b2.person_id = b1.id WHERE b2.tutorial_schedule_id = a0.id ORDER BY b1.first_name),',<br> ')", "")),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("TutorialSchedule", #class_name
      "Tutorial schedules in group", #header
      "(SELECT COUNT(*) FROM group_tutorial_schedules b1 WHERE b1.group_id = arg_value AND b1.tutorial_schedule_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='tutorial_schedules' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("TutorialSchedule", #class_name
      "Tutorial schedules not in group", #header
      "(SELECT COUNT(*) FROM group_tutorial_schedules b1 WHERE b1.group_id = arg_value AND b1.tutorial_schedule_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='tutorial_schedules' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
           ExtendedFilter.new(:external_filter, ExternalFilter.new("TutorialSchedule", #class_name
      "Tutorial Schedules in some group", #header
      "(SELECT COUNT(*) FROM group_tutorial_schedules b1 WHERE b1.tutorial_schedule_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
           ExtendedFilter.new(:external_filter, ExternalFilter.new("TutorialSchedule", #class_name
      "Tutorial Schedules not in any group", #header
      "(SELECT COUNT(*) FROM group_tutorial_schedules b1 WHERE b1.tutorial_schedule_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("TutorialSchedule", #class_name
      "Tutorial schedules attended by person", #header
      "(SELECT COUNT(*) FROM tutorials b1 WHERE b1.person_id = arg_value AND b1.tutorial_schedule_id = a0.id)>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      false,#allow_multiple_arguments
      true#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("TutorialSchedule", #class_name
      "Tutorial schedules not attended by person", #header
      "(SELECT COUNT(*) FROM tutorials b1 WHERE b1.person_id = arg_value AND b1.tutorial_schedule_id = a0.id)=0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("TutorialSchedule", #class_name
      "Tutorial schedules taught by person", #header
      "(a0.person_id = arg_value)", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      false,#allow_multiple_arguments
      true#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("TutorialSchedule", #class_name
      "Tutorial schedules not taught by person", #header
      "(a0.person_id != arg_value)", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("TutorialSchedule", #class_name
      "Tutorial schedules for course", #header
      "(a0.course_id = arg_value)", #where_str_
      "Course",#argument_class_
      "GroupCourse",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      false,#allow_multiple_arguments
      true#group_selector_
      )),
    ExtendedFilter.new(:external_filter, ExternalFilter.new("TutorialSchedule", #class_name
      "Tutorial schedules not for course", #header
      "(a0.course_id != arg_value)", #where_str_
      "Course",#argument_class_
      "GroupCourse",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("TutorialSchedule", #class_name
      "Tutorial schedules taught in term", #header
      "(a0.term_id = arg_value)", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("TutorialSchedule", #class_name
      "Tutorial schedules not taught in term", #header
      "(a0.term_id != arg_value)", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      ))
  ];
    extended_filters["User"]=[
       ExtendedFilter.new(:external_filter, ExternalFilter.new("User", #class_name
      "Users in group", #header
      "(SELECT COUNT(*) FROM group_users b1 WHERE b1.user_id = a0.id AND b1.group_id = arg_value)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='users' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("User", #class_name
      "Users not in group", #header
      "(SELECT COUNT(*) FROM group_users b1 WHERE b1.user_id = a0.id AND b1.group_id = arg_value)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='users' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_

    )),
       ExtendedFilter.new(:external_filter, ExternalFilter.new("User", #class_name
      "Users in some group", #header
      "(SELECT COUNT(*) FROM group_users b1 WHERE b1.user_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("User", #class_name
      "Users not in any group", #header
      "(SELECT COUNT(*) FROM group_users b1 WHERE b1.user_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      ))
  ];
    extended_filters["WillingLecturer"]=[]
    extended_filters["WillingTeacher"]=[]
    extended_filters["WillingTutor"]=[]
    
    extended_filters["Person"]=[
    ExtendedFilter.new(:subquery, SubQuery.new([],"Groups in", "groups_in" ,
      "array_to_string(ARRAY(SELECT CASE b1.group_id WHEN 1 THEN 'Not Set' ELSE b2.group_name END AS b1_group_id FROM group_people b1 INNER JOIN groups b2 ON b1.group_id = b2.id WHERE b1.person_id = a0.id ORDER BY b1_group_id asc),';<br>')", "")),
    ExtendedFilter.new(:subquery, SubQuery.new([],"Lectures attended in term", "lectures_attended_in_term" ,
      "array_to_string(ARRAY(SELECT CASE b1.lecture_id WHEN 1 THEN 'Not Set' ELSE b3.name END AS b1_lecture_id FROM attendees b1 INNER JOIN ( lectures b2 INNER JOIN courses b3 ON b2.course_id = b3.id) ON b1.lecture_id = b2.id WHERE (b1.person_id = a0.id AND b2.term_id = current_argument_value) ORDER BY b1_lecture_id asc),', <br>')", "Term")),
    ExtendedFilter.new(:subquery, SubQuery.new([],"Lectures attended", "lectures_attended" ,
      "array_to_string(ARRAY(SELECT CASE b1.lecture_id WHEN 1 THEN 'Not Set' ELSE b3.name || ', ' || SUBSTRING(b5.name,1,1) || SUBSTRING('' || b4.year,3,2)  END AS b1_lecture_id FROM attendees b1 INNER JOIN ( lectures b2 INNER JOIN courses b3 ON b2.course_id = b3.id INNER JOIN ( terms b4 INNER JOIN term_names b5 ON b4.term_name_id = b5.id ) ON b2.term_id = b4.id ) ON b1.lecture_id = b2.id WHERE (b1.person_id = a0.id ) ORDER BY b1_lecture_id asc),'; <br>')", "")),
    ExtendedFilter.new(:subquery, SubQuery.new([],"Tutorials taken in term", "tutorials_taken_in_term" ,
      "array_to_string(ARRAY(SELECT b3.name || ', ' || CASE b4.id WHEN 1 THEN 'Not Set' ELSE SUBSTRING(b4.first_name,1,1) || ' ' || b4.second_name END || ' ' || b2.number_of_tutorials AS b1_tutorial_schedule_id FROM tutorials b1 INNER JOIN ( tutorial_schedules b2 INNER JOIN courses b3 ON b2.course_id = b3.id INNER JOIN people b4 ON b4.id = b2.person_id) ON b1.tutorial_schedule_id = b2.id WHERE (b1.person_id = a0.id AND b2.term_id = current_argument_value) ORDER BY b1_tutorial_schedule_id asc),', <br>')", "Term")),
    ExtendedFilter.new(:subquery, SubQuery.new([],"Tutorials taken", "tutorials_taken" ,
      "array_to_string(ARRAY(SELECT  b3.name || ', ' || SUBSTRING(b5.name,1,1) || SUBSTRING('' || b4.year,3,2) || ', ' || CASE b6.id WHEN 1 THEN 'Not Set' ELSE SUBSTRING(b6.first_name,1,1) || ' ' || b6.second_name END || ' '  || b2.number_of_tutorials  AS b1_tutorial_schedule_id FROM tutorials b1 INNER JOIN ( tutorial_schedules b2 INNER JOIN courses b3 ON b2.course_id = b3.id INNER JOIN ( terms b4 INNER JOIN term_names b5 ON b4.term_name_id = b5.id ) ON b2.term_id = b4.id ) ON b1.tutorial_schedule_id = b2.id INNER JOIN people b6 ON b2.person_id = b6.id WHERE (b1.person_id = a0.id ) ORDER BY b1_tutorial_schedule_id asc),'; <br>')", "")),
    ExtendedFilter.new(:subquery, SubQuery.new([],"Collections NA", "collection_na" ,
      "array_to_string(ARRAY(SELECT b3.name || ', ' || SUBSTRING(b5.name,1,1) || SUBSTRING('' || b4.year,3,2) || ', ' || CASE b6.id WHEN 1 THEN 'Not Set' ELSE SUBSTRING(b6.first_name,1,1) || ' ' || b6.second_name END || ' ' || b2.number_of_tutorials AS b1_tutorial_schedule_id FROM tutorials b1 INNER JOIN ( tutorial_schedules b2 INNER JOIN courses b3 ON b2.course_id = b3.id INNER JOIN ( terms b4 INNER JOIN term_names b5 ON b4.term_name_id = b5.id ) ON b2.term_id = b4.id ) ON b1.tutorial_schedule_id = b2.id INNER JOIN people b6 ON b2.person_id = b6.id WHERE (b1.person_id = a0.id AND (b1.collection_status = 0 OR b1.collection_status IS NULL) ) ORDER BY b1_tutorial_schedule_id asc),'; <br>')", "")),
    ExtendedFilter.new(:subquery, SubQuery.new([],"Collections NA/Term", "collection_na_term" ,
      "array_to_string(ARRAY(SELECT b3.name || ', ' || CASE b4.id WHEN 1 THEN 'Not Set' ELSE SUBSTRING(b4.first_name,1,1) || ' ' || b4.second_name END || ' ' || b2.number_of_tutorials AS b1_tutorial_schedule_id FROM tutorials b1 INNER JOIN ( tutorial_schedules b2 INNER JOIN courses b3 ON b2.course_id = b3.id INNER JOIN people b4 ON b4.id = b2.person_id) ON b1.tutorial_schedule_id = b2.id WHERE (b1.person_id = a0.id AND (b1.collection_status = 0 OR b1.collection_status IS NULL) AND b2.term_id = current_argument_value) ORDER BY b1_tutorial_schedule_id asc),', <br>')", "Term")),
    ExtendedFilter.new(:subquery, SubQuery.new([],"Collections taken", "collection_taken" ,
      "array_to_string(ARRAY(SELECT b3.name || ', ' || SUBSTRING(b5.name,1,1) || SUBSTRING('' || b4.year,3,2) || ', ' || CASE b6.id WHEN 1 THEN 'Not Set' ELSE SUBSTRING(b6.first_name,1,1) || ' ' || b6.second_name END || ' ' || b2.number_of_tutorials AS b1_tutorial_schedule_id FROM tutorials b1 INNER JOIN ( tutorial_schedules b2 INNER JOIN courses b3 ON b2.course_id = b3.id INNER JOIN ( terms b4 INNER JOIN term_names b5 ON b4.term_name_id = b5.id ) ON b2.term_id = b4.id ) ON b1.tutorial_schedule_id = b2.id INNER JOIN people b6 ON b2.person_id = b6.id WHERE (b1.person_id = a0.id AND (b1.collection_status = 2) ) ORDER BY b1_tutorial_schedule_id asc),'; <br>')", "")),
    ExtendedFilter.new(:subquery, SubQuery.new([],"Collections taken/Term", "collection_taken_term" ,
      "array_to_string(ARRAY(SELECT b3.name || ', ' || CASE b4.id WHEN 1 THEN 'Not Set' ELSE SUBSTRING(b4.first_name,1,1) || ' ' || b4.second_name END || ' ' || b2.number_of_tutorials AS b1_tutorial_schedule_id FROM tutorials b1 INNER JOIN ( tutorial_schedules b2 INNER JOIN courses b3 ON b2.course_id = b3.id INNER JOIN people b4 ON b4.id = b2.person_id) ON b1.tutorial_schedule_id = b2.id WHERE (b1.person_id = a0.id AND (b1.collection_status =2) AND b2.term_id = current_argument_value) ORDER BY b1_tutorial_schedule_id asc),', <br>')", "Term")),
    ExtendedFilter.new(:subquery, SubQuery.new([],"Collections to be taken", "collection_to_be_taken" ,
      "array_to_string(ARRAY(SELECT b3.name || ', ' || SUBSTRING(b5.name,1,1) || SUBSTRING('' || b4.year,3,2) || ', ' || CASE b6.id WHEN 1 THEN 'Not Set' ELSE SUBSTRING(b6.first_name,1,1) || ' ' || b6.second_name END || ' ' || b2.number_of_tutorials AS b1_tutorial_schedule_id FROM tutorials b1 INNER JOIN ( tutorial_schedules b2 INNER JOIN courses b3 ON b2.course_id = b3.id INNER JOIN ( terms b4 INNER JOIN term_names b5 ON b4.term_name_id = b5.id ) ON b2.term_id = b4.id ) ON b1.tutorial_schedule_id = b2.id INNER JOIN people b6 ON b2.person_id = b6.id WHERE (b1.person_id = a0.id AND (b1.collection_status = 1) ) ORDER BY b1_tutorial_schedule_id asc),'; <br>')", "")),
    ExtendedFilter.new(:subquery, SubQuery.new([],"Collections to be taken/Term", "collection_to_be_taken_term" ,
      "array_to_string(ARRAY(SELECT b3.name || ', ' || CASE b4.id WHEN 1 THEN 'Not Set' ELSE SUBSTRING(b4.first_name,1,1) || ' ' || b4.second_name END || ' ' || b2.number_of_tutorials AS b1_tutorial_schedule_id FROM tutorials b1 INNER JOIN ( tutorial_schedules b2 INNER JOIN courses b3 ON b2.course_id = b3.id INNER JOIN people b4 ON b4.id = b2.person_id) ON b1.tutorial_schedule_id = b2.id WHERE (b1.person_id = a0.id AND (b1.collection_status =1) AND b2.term_id = current_argument_value) ORDER BY b1_tutorial_schedule_id asc),', <br>')", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Number of lecture courses attended", "number_of_lectures_courses_attended" ,
      "(SELECT COUNT(*) FROM lectures b1 INNER JOIN attendees b2 ON b2.lecture_id = b1.id WHERE b1.term_id = current_argument_value AND b2.person_id = a0.id)", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Number of lectures attended", "number_of_lectures_attended" ,
      "(SELECT COALESCE(SUM(b1.number_of_lectures),0) FROM lectures b1 INNER JOIN attendees b2 ON b2.lecture_id = b1.id WHERE b1.term_id = current_argument_value AND b2.person_id = a0.id)", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Number of classes attended", "number_of_classes_attended" ,
      "(SELECT COALESCE(SUM(b1.number_of_classes),0) FROM lectures b1 INNER JOIN attendees b2 ON b2.lecture_id = b1.id WHERE b1.term_id = current_argument_value AND b2.person_id = a0.id)", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Number of lecture hours attended", "number_of_lecture_hours_attended" ,
      "(SELECT COALESCE(SUM(b1.hours),0) FROM lectures b1 INNER JOIN attendees b2 ON b2.lecture_id = b1.id WHERE b1.term_id = current_argument_value AND b2.person_id = a0.id)", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Number of tutorial courses attended", "number_of_tutorial_courses_hours_attended" ,
      "(SELECT COUNT(*) FROM tutorial_schedules b1 INNER JOIN tutorials b2 ON b2.tutorial_schedule_id = b1.id WHERE b1.term_id = current_argument_value AND b2.person_id = a0.id)", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Number of tutorials attended", "number_of_tutorials_attended" ,
      "(SELECT COALESCE(SUM(b1.number_of_tutorials),0) FROM tutorial_schedules b1 INNER JOIN tutorials b2 ON b2.tutorial_schedule_id = b1.id WHERE b1.term_id = current_argument_value AND b2.person_id = a0.id)", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Number of tutorial hours attended", "number_of_tutorial_hours_attended" ,
      "(SELECT COALESCE(SUM(b1.number_of_tutorial_hours),0) FROM tutorial_schedules b1 INNER JOIN tutorials b2 ON b2.tutorial_schedule_id = b1.id WHERE b1.term_id = current_argument_value AND b2.person_id = a0.id)", "Term")),

  ExtendedFilter.new(:subquery, SubQuery.new([],"Lectures given in term", "lectures_given_in_term" ,
      "array_to_string(ARRAY(SELECT b2.name AS b1_course_id FROM lectures b1 INNER JOIN courses b2 ON b1.course_id = b2.id  WHERE (b1.person_id = a0.id AND  b1.term_id = current_argument_value) ORDER BY b1_course_id asc),', <br>')", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Lectures given", "lectures_given" ,
      "array_to_string(ARRAY(SELECT b2.name || ', ' || SUBSTRING(b4.name,1,1) || SUBSTRING(''||b3.year,3,2) AS b1_course_id FROM lectures b1 INNER JOIN courses b2 ON b1.course_id = b2.id  INNER JOIN ( terms b3 INNER JOIN term_names b4 ON b3.term_name_id = b4.id ) ON b1.term_id = b3.id WHERE (b1.person_id = a0.id) ORDER BY b1_course_id asc),', <br>')", "")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Tutorials given in term", "tutorials_given_in_term" ,
      "array_to_string(ARRAY(SELECT b4.name || ', ' || CASE b3.id WHEN 1 THEN 'Not Set' ELSE SUBSTRING(b3.first_name,1,1) || ' ' || b3.second_name END || ' '|| b2.number_of_tutorials AS b1_tutorial FROM tutorials b1 INNER JOIN (tutorial_schedules b2 INNER JOIN courses b4 ON b4.id = b2.course_id)  ON b2.id = b1.tutorial_schedule_id INNER JOIN people b3 ON b1.person_id = b3.id WHERE b2.person_id = a0.id AND b2.term_id = current_argument_value ORDER BY b1_tutorial asc),',<br>')", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Tutorials given", "tutorials_given" ,
      "array_to_string(ARRAY(SELECT b4.name || ', ' || SUBSTRING(b6.name,1,1) || SUBSTRING(''||b5.year,3,2) || ', ' || CASE b3.id WHEN 1 THEN 'Not Set' ELSE SUBSTRING(b3.first_name,1,1) || ' ' || b3.second_name END ||  ' '|| b2.number_of_tutorials AS b1_tutorial FROM tutorials b1 INNER JOIN (tutorial_schedules b2 INNER JOIN courses b4 ON b4.id = b2.course_id INNER JOIN (terms b5 INNER JOIN term_names b6 ON b5.term_name_id = b6.id) ON b5.id = b2.term_id)  ON b2.id = b1.tutorial_schedule_id INNER JOIN people b3 ON b1.person_id = b3.id WHERE b2.person_id = a0.id ORDER BY b1_tutorial asc),',<br>')", "")),

  ExtendedFilter.new(:subquery, SubQuery.new([],"Number of lecture courses taught", "number_of_lecture_coureses_taught" ,
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.term_id = current_argument_value AND b1.person_id = a0.id)", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Number of lectures taught", "number_of_lectures_taught" ,
      "(SELECT COALESCE(SUM(b1.number_of_lectures),0) FROM lectures b1 WHERE b1.term_id = current_argument_value AND b1.person_id = a0.id)", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Number of classes taught", "number_of_classes_taught" ,
      "(SELECT COALESCE(SUM(b1.number_of_classes),0) FROM lectures b1 WHERE b1.term_id = current_argument_value AND b1.person_id = a0.id)", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Number of lecture hours taught", "number_of_lecture_hours_taught" ,
      "(SELECT COALESCE(SUM(b1.hours),0) FROM lectures b1 WHERE b1.term_id = current_argument_value AND b1.person_id = a0.id)", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Number of tutorial courses taught", "number_of_tutorial_courses_taught" ,
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.term_id = current_argument_value AND b1.person_id = a0.id)", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Number of tutorials taught", "number_of_tutorials_taught" ,
      "(SELECT COALESCE(SUM(b1.number_of_tutorials),0) FROM tutorial_schedules b1 WHERE b1.term_id = current_argument_value AND b1.person_id = a0.id)", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Number of tutorial hours taught", "number_of_tutorial_hours_taught" ,
      "(SELECT COALESCE(SUM(a1.number_of_tutorial_hours),0) FROM tutorial_schedules a1 WHERE a1.term_id = current_argument_value AND a1.person_id = a0.id)", "Term")),
  ExtendedFilter.new(:subquery, SubQuery.new([],"Maxiumum tutorials in term", "max_tutorials_in_term" ,
      "(SELECT SUM(a1.max_tutorials) FROM maximum_tutorials a1 WHERE a1.term_id = current_argument_value AND a1.person_id = a0.id)", "Term")),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People in group", #header
      "(SELECT COUNT(*) FROM group_people b1 WHERE b1.person_id = a0.id AND b1.group_id = arg_value)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='people' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_
      )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People not in group", #header
      "(SELECT COUNT(*) FROM group_people b1 WHERE b1.person_id = a0.id AND b1.group_id = arg_value)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(false,\"asc\", false, \"\", \"a0.table_name ='people' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) )\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false#group_selector_

    )),
     ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People in some group", #header
      "(SELECT COUNT(*) FROM group_people b1 WHERE b1.person_id = a0.id)>0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
           ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People not in any group", #header
      "(SELECT COUNT(*) FROM group_people b1 WHERE b1.person_id = a0.id)=0", #where_str_
      "Group",#argument_class_
      "",#group_class_
      "[]", #argument_selector_str_
      false,#allow_multiple_arguments
      false#group_selector_
      )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have attended lectures", #header
      "(SELECT COUNT(*) FROM attendees b1 WHERE b1.person_id = a0.id AND b1.lecture_id = arg_value)>0", #where_str_
      "Lecture",#argument_class_
      "GroupLecture",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have not attended lectures", #header
      "(SELECT COUNT(*) FROM attendees b1 WHERE b1.person_id = a0.id AND b1.lecture_id = arg_value)=0", #where_str_
      "Lecture",#argument_class_
      "GroupLecture",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People to be examined on lectures", #header
      "(SELECT COUNT(*) FROM attendees b1 WHERE b1.person_id = a0.id AND b1.lecture_id = arg_value AND b1.examined = true )>0 ", #where_str_
      "Lecture",#argument_class_
      "GroupLecture",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People not to be examined on lectures", #header
      "(SELECT COUNT(*) FROM attendees b1 WHERE b1.person_id = a0.id AND b1.lecture_id = arg_value AND b1.examined = false)>0 ", #where_str_
      "Lecture",#argument_class_
      "GroupLecture",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who must attend lectures", #header
      "(SELECT COUNT(*) FROM attendees b1 WHERE b1.person_id = a0.id AND b1.lecture_id = arg_value AND b1.compulsory = true)>0 ", #where_str_
      "Lecture",#argument_class_
      "GroupLecture",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who optionally attend lectures", #header
      "(SELECT COUNT(*) FROM attendees b1 WHERE b1.person_id = a0.id AND b1.lecture_id = arg_value AND b1.compulsory = false)>0 ", #where_str_
      "Lecture",#argument_class_
      "GroupLecture",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have attended course lectures", #header
      "(SELECT COUNT(*) FROM attendees b1 INNER JOIN lectures b2 ON b2.id = b1.lecture_id WHERE b2.course_id = arg_value AND b1.person_id = a0.id)>0", #where_str_
      "Course",#argument_class_
      "GroupCourse",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have not attended course lectures", #header
      "(SELECT COUNT(*) FROM attendees b1 INNER JOIN lectures b2 ON b2.id = b1.lecture_id WHERE b2.course_id = arg_value AND b1.person_id = a0.id)=0", #where_str_
      "Course",#argument_class_
      "GroupCourse",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have attended course tutorials", #header
      "(SELECT COUNT(*) FROM tutorials b1 INNER JOIN tutorial_schedules b2 ON b2.id = b1.tutorial_schedule_id WHERE b2.course_id = arg_value AND b1.person_id = a0.id)>0", #where_str_
      "Course",#argument_class_
      "GroupCourse",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
    ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have not attended course tutorials", #header
      "(SELECT COUNT(*) FROM tutorials b1 INNER JOIN tutorial_schedules b2 ON b2.id = b1.tutorial_schedule_id WHERE b2.course_id = arg_value AND b1.person_id = a0.id)=0", #where_str_
      "Course",#argument_class_
      "GroupCourse",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
    ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have been lectured by person", #header
      "(SELECT COUNT(*) FROM attendees b1 INNER JOIN lectures b2 ON b2.id = b1.lecture_id WHERE b1.person_id = a0.id AND b2.person_id = arg_value)>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have not been lectured by person", #header
      "(SELECT COUNT(*) FROM attendees b1 INNER JOIN lectures b2 ON b2.id = b1.lecture_id WHERE b1.person_id = a0.id AND b2.person_id = arg_value)=0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have been tutored by person", #header
      "(SELECT COUNT(*) FROM tutorials b1 INNER JOIN tutorial_schedules b2 ON b2.id = b1.tutorial_schedule_id WHERE b1.person_id = a0.id AND b2.person_id = arg_value)>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
        ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have not been tutored by person", #header
      "(SELECT COUNT(*) FROM tutorials b1 INNER JOIN tutorial_schedules b2 ON b2.id = b1.tutorial_schedule_id WHERE b1.person_id = a0.id AND b2.person_id = arg_value)=0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
   ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have been lectured in term", #header
      "(SELECT COUNT(*) FROM attendees b1 INNER JOIN lectures b2 ON b2.id = b1.lecture_id WHERE b1.person_id = a0.id AND b2.term_id = arg_value)>0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false #group_selector_
    )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have not been lectured in term", #header
      "(SELECT COUNT(*) FROM attendees b1 INNER JOIN lectures b2 ON b2.id = b1.lecture_id WHERE b1.person_id = a0.id AND b2.term_id = arg_value)=0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false #group_selector_
    )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have been tutored in term", #header
      "(SELECT COUNT(*) FROM tutorials b1 INNER JOIN tutorial_schedules b2 ON b2.id = b1.tutorial_schedule_id WHERE b1.person_id = a0.id AND b2.term_id = arg_value)>0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false #group_selector_
    )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have not been tutored in term", #header
      "(SELECT COUNT(*) FROM tutorials b1 INNER JOIN tutorial_schedules b2 ON b2.id = b1.tutorial_schedule_id WHERE b1.person_id = a0.id AND b2.term_id = arg_value)=0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false #group_selector_
    )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have lectured course", #header
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.course_id = arg_value AND b1.person_id = a0.id)>0", #where_str_
      "Course",#argument_class_
      "GroupCourse",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have not lectured course", #header
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.course_id = arg_value AND b1.person_id = a0.id)=0", #where_str_
      "Course",#argument_class_
      "GroupCourse",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
  ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have tutored course", #header
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.course_id = arg_value AND b1.person_id = a0.id)>0", #where_str_
      "Course",#argument_class_
      "GroupCourse",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
    ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have not tutored course", #header
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.course_id = arg_value AND b1.person_id = a0.id)=0", #where_str_
      "Course",#argument_class_
      "GroupCourse",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have lectured person", #header
      "(SELECT COUNT(*) FROM attendees b1 INNER JOIN lectures b2 ON b2.id = b1.lecture_id WHERE b2.person_id = a0.id AND b1.person_id = arg_value)>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
        ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have not lectured person", #header
      "(SELECT COUNT(*) FROM attendees b1 INNER JOIN lectures b2 ON b2.id = b1.lecture_id WHERE b2.person_id = a0.id AND b1.person_id = arg_value)=0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have tutored person", #header
      "(SELECT COUNT(*) FROM tutorials b1 INNER JOIN tutorial_schedules b2 ON b2.id = b1.tutorial_schedule_id WHERE b2.person_id = a0.id AND b1.person_id = arg_value)>0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
    ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have not tutored person", #header
      "(SELECT COUNT(*) FROM tutorials b1 INNER JOIN tutorial_schedules b2 ON b2.id = b1.tutorial_schedule_id WHERE b2.person_id = a0.id AND b1.person_id = arg_value)=0", #where_str_
      "Person",#argument_class_
      "GroupPerson",#group_class_
      "@selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller,false)", #argument_selector_str_
      true,#allow_multiple_arguments
      true #group_selector_
    )),
    ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have lectured in term", #header
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.person_id = a0.id AND b1.term_id = arg_value)>0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false #group_selector_
    )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have not lectured in term", #header
      "(SELECT COUNT(*) FROM lectures b1 WHERE b1.person_id = a0.id AND b1.term_id = arg_value)=0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false #group_selector_
    )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have tutored in term", #header
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.person_id = a0.id AND b1.term_id = arg_value)>0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false #group_selector_
    )),
      ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who have not tutored in term", #header
      "(SELECT COUNT(*) FROM tutorial_schedules b1 WHERE b1.person_id = a0.id AND b1.term_id = arg_value)=0", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false #group_selector_
    )),
     ExtendedFilter.new(:external_filter, ExternalFilter.new("Person", #class_name
      "People who tutoring too much in term", #header
      "(SELECT COALESCE(SUM(a1.number_of_tutorial_hours),0) FROM tutorial_schedules a1 WHERE a1.term_id = arg_value AND a1.person_id = a0.id)> (SELECT COALESCE(SUM(a1.max_tutorials),99999) FROM maximum_tutorials a1 WHERE a1.term_id = arg_value AND a1.person_id = a0.id)", #where_str_
      "Term",#argument_class_
      "",#group_class_
      "@class_search_controller.GetAllShortFieldsWhere(true,\"desc\", false, \"\", \"\")", #argument_selector_str_
      true,#allow_multiple_arguments
      false #group_selector_
    ))
  ];


    session[:extended_filters] = extended_filters;

  end

end
