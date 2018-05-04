# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
  User.destroy_all
  user1 = User.create!(username: 'chefboyarsteve')
  user2 = User.create!(username: 'jimmyhendricks')
  user3 = User.create!(username: 'patrickstar')

  Poll.destroy_all
  poll1 = Poll.create!(title: 'Gangster Test', user_id: user1.id)
  poll2 = Poll.create!(title: 'True Gamer Test', user_id: user2.id)
  poll3 = Poll.create!(title: 'Harry Potter Test', user_id: user3.id)

  Question.destroy_all
  question1 = Question.create!(question: 'How often do you fight?', poll_id: poll1.id)
  question2 = Question.create!(question: 'What color do you wear?', poll_id: poll1.id)
  question3 = Question.create!(question: 'Do you play video games?', poll_id: poll2.id)
  question4 = Question.create!(question: 'What does GG mean?', poll_id: poll2.id)
  question5 = Question.create!(question: 'Do you own a wand?', poll_id: poll3.id)
  question6 = Question.create!(question: 'What do you think of Hermione?', poll_id: poll3.id)

  AnswerChoice.destroy_all
  answer1 = AnswerChoice.create!(answer_choice: 'all the time', question_id: question1.id)
  answer2 = AnswerChoice.create!(answer_choice: 'never', question_id: question1.id)
  answer3 = AnswerChoice.create!(answer_choice: 'black', question_id: question2.id)
  answer4 = AnswerChoice.create!(answer_choice: 'white', question_id: question2.id)
  answer5 = AnswerChoice.create!(answer_choice: 'yes', question_id: question3.id)
  answer6 = AnswerChoice.create!(answer_choice: 'no', question_id: question3.id)
  answer7 = AnswerChoice.create!(answer_choice: 'good game', question_id: question4.id)
  answer8 = AnswerChoice.create!(answer_choice: 'grand game', question_id: question4.id)
  answer9 = AnswerChoice.create!(answer_choice: 'Yes', question_id: question5.id)
  answer10 = AnswerChoice.create!(answer_choice: 'no', question_id: question5.id)
  answer11 = AnswerChoice.create!(answer_choice: 'fire', question_id: question6.id)
  answer12 = AnswerChoice.create!(answer_choice: 'nahh', question_id: question6.id)

  Response.destroy_all
  Response.create!(answer_choice_id: answer1.id, user_id: user2.id)
  Response.create!(answer_choice_id: answer1.id, user_id: user3.id)
  Response.create!(answer_choice_id: answer3.id, user_id: user2.id)
  Response.create!(answer_choice_id: answer5.id, user_id: user3.id)
  Response.create!(answer_choice_id: answer7.id, user_id: user3.id)
  Response.create!(answer_choice_id: answer9.id, user_id: user1.id)
  Response.create!(answer_choice_id: answer11.id, user_id: user1.id)
end
