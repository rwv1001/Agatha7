class CreateAgathaEmailFiles < ActiveRecord::Migration
  def self.up
    create_table :email_attachments do |t|
      t.integer :agatha_email_id
      t.integer :agatha_file_id

      t.timestamps
    end
  end

  def self.down
    drop_table :email_attachments
  end
end
