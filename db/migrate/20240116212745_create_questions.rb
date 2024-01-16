class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.integer :poll_id, null: false
      t.timestamps
    end
  end
end
