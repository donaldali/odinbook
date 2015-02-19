class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string     :content
      t.references :post
      t.references :commenter

      t.timestamps
    end

    add_index :comments, :post_id
    add_index :comments, :commenter_id
  end
end
