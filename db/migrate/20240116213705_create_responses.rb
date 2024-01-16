class CreateResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :responses do |t|
      t.integer :responded_id, null: false
      t.integer :answer_id, null: false
      t.timestamps
    end
  end
end
