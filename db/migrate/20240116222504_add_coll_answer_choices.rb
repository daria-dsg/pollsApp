class AddCollAnswerChoices < ActiveRecord::Migration[7.1]
  def change
    add_column :answer_choices, :question_id, :integer, null: false 
  end
end
