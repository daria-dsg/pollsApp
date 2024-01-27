class Response < ApplicationRecord
  validates :respondent_id, presence: true
  validates :answer_choice_id, presence: true
  validate :not_duplicate_response, :respondent_is_not_pull_author

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

  def respondent_already_answered?
    sibling_responses.exists?(respondent_id: self.respondent_id)
  end

  def not_duplicate_response
    if respondent_already_answered?
      errors.add(:respondent, 'can not vote twice for the question')
    end
  end

  def respondent_is_not_pull_author
    poll = Poll
      .joins(questions: :answer_choices)
      .where('answer_choices.id = ?', self.answer_choice_id)
      .first

    if self.respondent_id == poll.author_id
      errors.add(:author, 'can not respond on own poll')
    end
  end
end