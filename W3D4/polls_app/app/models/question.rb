# == Schema Information
#
# Table name: questions
#
#  id         :bigint(8)        not null, primary key
#  question   :text             not null
#  poll_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Question < ApplicationRecord

  validates :poll_id, :question, presence: true
  validates :poll_id, uniqueness: {scope: :question}

  belongs_to :poll,
  primary_key: :id,
  foreign_key: :poll_id,
  class_name: :Poll

  has_many :answer_choices,
  primary_key: :id,
  foreign_key: :question_id,
  class_name: :AnswerChoice

  has_many :responses,
  through: :answer_choices,
  source: :responses
end
