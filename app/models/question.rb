class Question < ApplicationRecord
  validates :title, presence: true

  has_many :answer_choices,
    class_name: 'AnswerChoice',
    primary_key: :id,
    foreign_key: :question_id

  belongs_to :poll,
    class_name: 'Poll',
    primary_key: :id,
    foreign_key: :poll_id

  has_many :responses,
    through: :answer_choices,
    source: :responses

  def n_plus_one_result
    answer_choices = self.answer_choices

    answer_choices_responses_count = {}

    answer_choices.each do |answer_choice|
      answer_choices_responses_count[answer_choice.text] = answer_choice.responses.count
    end

    answer_choices_responses_count
  end
end