class CreateAgathaEmails < ActiveRecord::Migration
  def self.up
    create_table :agatha_emails do |t|
      t.string :from_email, :default => ""
      t.string :to_email, :default => ""
      t.string :subject, :default => ""
      t.text :body, :default => ""
      t.string :attachments, :default => ""
      t.boolean :sent, :default => false
      t.integer :template_id, :default => 1
      t.integer :person_id, :default => 1
      t.integer :term_id, :default => 1
      t.integer :course_id, :default => 1
      t.string :attached_files

      t.timestamps
    end
  end

  def self.down
    drop_table :agatha_emails
  end
end
