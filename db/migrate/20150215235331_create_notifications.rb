class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :message
      t.string :notification_type
      t.string :sender
      t.references :user

      t.timestamps
    end
    add_index :notifications, :user_id
  end
end
