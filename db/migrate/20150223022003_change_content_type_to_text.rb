class ChangeContentTypeToText < ActiveRecord::Migration
  def change
    change_column :posts,    :content, :text
    change_column :comments, :content, :text
  end
end
