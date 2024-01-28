class AnswerChoice < ApplicationRecord
  validates :text, presence: true

  has_many :responses,
    class_name: 'Response',
    primary_key: :id,
    foreign_key: :answer_choice_id

  belongs_to :question,
    class_name: 'Question',
    primary_key: :id,
    foreign_key: :question_id
end