class AddNewNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :new_notifications, :integer, default: 0
  end
end
