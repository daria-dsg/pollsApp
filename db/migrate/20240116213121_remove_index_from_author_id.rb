class RemoveIndexFromAuthorId < ActiveRecord::Migration[7.1]
  def change
    remove_index :polls, :author_id
  end
end
