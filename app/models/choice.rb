class Choice < ApplicationRecord
  belongs_to :question
  validates :option, presence: true
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "option", "question_id", "updated_at"]
  end
end
