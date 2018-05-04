# == Schema Information
#
# Table name: responses
#
#  id               :bigint(8)        not null, primary key
#  user_id :integer          not null
#  user_id          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Response < ApplicationRecord

  validates :answer_choice_id, :user_id, presence: true
  validates :answer_choice_id, uniqueness: {scope: :user_id}, :message => "Cant answer same question"
  validate :respondent_already_answered?
  validate :user_created_the_poll

  belongs_to :respondent,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :User

  belongs_to :answer_choice,
  primary_key: :id,
  foreign_key: :answer_choice_id,
  class_name: :AnswerChoice

  has_one :question,
  through: :answer_choice,
  source: :question

  def sibling_responses
    self.question.responses.where.not(id: self.id)
  end

  def respondent_already_answered?
    sibling_responses.exists?(user_id: self.user_id)
  end

  def author_created_poll?
    self.question.poll.user_id == self.user_id
  end

  private

  def Respondent_already_answered_question
    if respondent_already_answered?
      errors[:user_id] << 'Cant answer the same question twice'
    end
  end

  def user_created_the_poll
    if author_created_poll?
      errors[:user_id] << 'Cant answer the question, you created it!'
    end
  end

end
