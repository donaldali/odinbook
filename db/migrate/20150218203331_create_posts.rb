class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string     :content
      t.references :creator
      t.references :receiver

      t.timestamps
    end

    add_index :posts, :creator_id
    add_index :posts, :receiver_id
  end
end
