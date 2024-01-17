class AddColAnswerChoiceIdResponses < ActiveRecord::Migration[7.1]
  def change
    add_column :responses, :answer_choice_id, :integer, null: false
  end
end
