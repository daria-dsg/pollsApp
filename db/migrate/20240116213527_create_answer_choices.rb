class CreateAnswerChoices < ActiveRecord::Migration[7.1]
  def change
    create_table :answer_choices do |t|
      t.string :text, null: false
      t.integer :poll_id, null: false
      t.timestamps
    end
  end
end
