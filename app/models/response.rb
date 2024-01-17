class Response < ApplicationRecord
  validates :responded_id, presence: true
  validates :answer_id, presence: true

  belongs_to :answer_choice,
    class_name: 'AnswerChoice',
    primary_key: :id,
    foreign_key: :answer_id

  belongs_to :respondent,
    class_name: 'Response',
    primary_key: :id,
    foreign_key: :responded_id
end