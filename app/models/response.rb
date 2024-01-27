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

  def sibling_responses
    self.question.responses.where.not(id: self.id)
  end

  def sibling_responses_improved
    binds = {answer_choice_id: self.answer_choice_id, id: self.id}

    Response.find_by_sql([<<-SQL, binds])
      SELECT
        responses.*
      FROM (
        SELECT
          questions.*
        FROM
          questions
        JOIN 
          answer_choices ON questions.id = answer_choices.question_id
        WHERE 
          answer_choices.id = :answer_choice_id
      ) AS questions
      JOIN 
        answer_choices ON questions.id = answer_choices.question_id
      JOIN 
        responses ON answer_choices.id = responses.answer_choice_id
      WHERE 
        (:id IS NULL) OR (responses.id != :id)
      SQL
  end
end