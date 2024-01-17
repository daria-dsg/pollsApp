class Response < ApplicationRecord
  validates :respondent_id, presence: true
  validates :answer_choice_id, presence: true

  belongs_to :answer_choice,
    class_name: 'AnswerChoice',
    primary_key: :id,
    foreign_key: :answer_choice_id

  belongs_to :respondent,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :respondent_id

  has_one :question,
    through: :answer_choice,
    source: :question
end