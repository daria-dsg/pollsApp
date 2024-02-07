class User < ApplicationRecord
  validates :name, uniqueness: true, presence: true

  has_many :authored_polls,
    class_name: 'Poll',
    primary_key: :id,
    foreign_key: :author_id

  has_many :responses,
    class_name: 'Response',
    primary_key: :id,
    foreign_key: :respondent_id

    def completed_polls_sql
      Poll.find_by_sql(<<-SQL)
        SELECT
          polls.*
        FROM
          polls
        JOIN 
          questions ON polls.id = questions.poll_id
        JOIN
          answer_choices ON questions.id = answer_choices.question_id
        LEFT OUTER JOIN (
          SELECT
           *
          FROM
            responses
          WHERE
            respondent_id = #{self.id}
        ) AS responses ON answer_choices.id = responses.answer_choice_id
        GROUP BY 
          polls.id
        HAVING
          COUNT(DISTINCT questions.id) = COUNT(responses.id)
      SQL
    end

    def completed_polls
      polls_with_all_counts
        .having('COUNT(DISTINCT questions.id) > COUNT(responses.id)')
        .having('COUNT(responses.id)')
    end

    def uncompleted_polls
      polls_with_all_counts.having('COUNT(DISTINCT questions.id) != COUNT(responses.id)')
    end

    private

    def polls_with_all_counts
      response_join = <<-SQL
        LEFT OUTER JOIN (
          SELECT
            *
          FROM
            responses
          WHERE
            respondent_id = #{self.id}
        ) AS responses ON answer_choices.id = responses.answer_choice_id
      SQL

      Poll.joins(questions: :answer_choices)
           .joins(response_join)
           .group(:id)
    end
end