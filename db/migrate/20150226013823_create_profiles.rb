class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.date       :birthday
      t.string     :country
      t.string     :education
      t.string     :profession
      t.text       :about_you
      t.string     :access_to
      t.boolean    :email_notification
      t.references :user

      t.timestamps
    end

    add_index :profiles, :user_id
  end
end
