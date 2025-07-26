class CreateEmailTemplates < ActiveRecord::Migration
  def self.up
    create_table :email_templates do |t|
      t.string :template_name, :default => ""
      t.string :from_email, :default => ""
      t.string :subject, :default => ""
      t.text :ruby_header, :default => ""
      t.text :body, :default => ""
      t.integer :attachment_rule_id, :default => 1
      t.string :attachment_file_list, :default => ""
      t.boolean :term_dependency, :default => true
      t.boolean :course_dependency, :default => false
      t.text :global_warnings, :default => ""
      t.text :personal_warnings, :default => ""

      t.timestamps
    end
  end

  def self.down
    drop_table :email_templates
  end
end
