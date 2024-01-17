class DeleteColResponses < ActiveRecord::Migration[7.1]
  def change
    remove_column :responses, :responded_id
  end
end
