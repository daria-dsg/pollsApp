class DeleteColAnswerIdResponses < ActiveRecord::Migration[7.1]
  def change
    remove_column :responses, :answer_id
  end
end
