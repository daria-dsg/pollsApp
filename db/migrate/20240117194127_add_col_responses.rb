class AddColResponses < ActiveRecord::Migration[7.1]
  def change
    add_column :responses, :respondent_id, :integer, null: false
  end
end
