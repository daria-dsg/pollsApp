# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ActiveRecord::Base.transaction do
  User.destroy_all
  Poll.destroy_all
  Question.destroy_all
  AnswerChoice.destroy_all
  Response.destroy_all

  u1 = User.create!(name: 'Markov')
  u2 = User.create!(name: 'Gizmo')
  u3 = User.create!(name: 'Daria')
  u4 = User.create!(name: 'Alex')

  p1 = Poll.create!(title: 'Cats Poll', author: u1)

  q1 = Question.create!(title: 'What Cat Is Cutest?', poll: p1)
  ac1 = AnswerChoice.create!(text: 'Markov', question: q1)
  ac2 = AnswerChoice.create!(text: 'Curie', question: q1)
  ac3 = AnswerChoice.create!(text: 'Sally', question: q1)

  q2 = Question.create!(title: 'Which Toy Is Most Fun?', poll: p1)
  ac4 = AnswerChoice.create!(text: 'String', question: q2)
  ac5 = AnswerChoice.create!(text: 'Ball', question: q2)
  ac6 = AnswerChoice.create!(text: 'Bird', question: q2)

  r1 = Response.create!(respondent: u2, answer_choice: ac3)
  r2 = Response.create!( respondent: u2, answer_choice: ac4)
  r3 = Response.create!( respondent: u3, answer_choice: ac4)
  r4 = Response.create!( respondent: u4, answer_choice: ac5)
end

