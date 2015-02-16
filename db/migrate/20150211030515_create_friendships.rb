class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.references :friender
      t.references :friended
      t.boolean    :accepted

      t.timestamps
    end

    add_index :friendships, :friender_id
    add_index :friendships, :friended_id
    add_index :friendships, [:friender_id, :friended_id], unique: true
  end
end
