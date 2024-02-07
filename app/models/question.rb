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
    
  def results_n_plus_one
    # n+1 solution to return hash of count of responses per answer choice
    answer_choices = self.answer_choices

    answer_choices_responses_count = {}

    answer_choices.each do |answer_choice|
      answer_choices_responses_count[answer_choice.text] = answer_choice.responses.count
    end

    answer_choices_responses_count
  end

  def results_2_queries
    # 2 queries; all responses are transfered
    answer_choices = self.answer_choices.includes(:responses)

    answer_choices_responses_count = {}

    answer_choices.each do |answer_choice|
      answer_choices_responses_count[answer_choice.text] = answer_choice.responses.length
    end

    answer_choices_responses_count
  end

  def results_1_query_SQL
    # 1 query all SQL
    ac = AnswerChoice.find_by_sql([<<-SQL, id])
      SELECT
        answer_choices.text, COUNT(responses.id) AS num_responses
      FROM
        answer_choices
      LEFT OUTER JOIN
        responses ON answer_choices.id = responses.answer_choice_id
      WHERE
        answer_choices.question_id = ?
      GROUP BY
        answer_choices.id
      SQL

    ac.inject({}) do |results, ac|
      results[ac.text] = ac.num_responses
      results
    end
  end

  def results
    #1-query way w/ ActiveRecord
    ac = AnswerChoice
      .select("answer_choices.text, COUNT(responses.id) AS num_responses")
      .left_outer_joins(:responses)
      .where(["answer_choices.question_id = ?", self.id])
      .group("answer_choices.id")

    ac.inject({}) do |results, ac|
      results[ac.text] = ac.num_responses
      results
      end
  end
end