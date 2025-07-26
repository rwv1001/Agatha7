class IndexAddition < ActiveRecord::Migration
  def self.up
    add_index :people, [:first_name, :second_name], :unique => false
    add_index :agatha_emails, :person_id,  :unique => false
    add_index :agatha_emails, :term_id, :unique => false
    add_index :attendees, :lecture_id, :unique => false
    add_index :attendees, :person_id, :unique => false
    add_index :display_filters, :user_id,  :unique => false
    add_index :external_filter_values, :user_id,  :unique => false
    add_index :format_elements, :user_id,  :unique => false
    add_index :group_filters, :user_id,  :unique => false
    add_index :lectures, :course_id,  :unique => false
    add_index :lectures, :person_id,  :unique => false
    add_index :lectures, :term_id,  :unique => false
    add_index :lectures, :day_id,  :unique => false
    add_index :maximum_tutorials, :person_id,  :unique => false
    add_index :maximum_tutorials, :term_id,  :unique => false
    add_index :open_records, :user_id,  :unique => false
    add_index :terms, :term_name_id,  :unique => false
    add_index :tutorial_schedules, :person_id,  :unique => false
    add_index :tutorial_schedules, :course_id,  :unique => false
    add_index :tutorial_schedules, :term_id,  :unique => false
    add_index :tutorials, :person_id,  :unique => false
    add_index :tutorials, :tutorial_schedule_id,  :unique => false
    add_index :user_pages, :user_id,  :unique => false
    add_index :willing_lecturers, :person_id,  :unique => false
    add_index :willing_lecturers, :course_id,  :unique => false
    add_index :willing_tutors, :person_id,  :unique => false
    add_index :willing_tutors, :course_id,  :unique => false
    add_index :email_attachments, [:agatha_email_id, :agatha_file_id], :unique => false
  end

  def self.down
  end
end
