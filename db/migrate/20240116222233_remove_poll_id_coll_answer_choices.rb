class RemovePollIdCollAnswerChoices < ActiveRecord::Migration[7.1]
  def change
    remove_column :answer_choices, :poll_id
  end
end
