class CreateGroupAgathaEmails < ActiveRecord::Migration
  def self.up
    create_table :group_agatha_emails do |t|
      t.integer :group_id
      t.integer :agatha_email_id

      t.timestamps
    end
  end

  def self.down
    drop_table :group_agatha_emails
  end
end
