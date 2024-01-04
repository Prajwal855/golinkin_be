class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :cv
  has_one_attached :photo
  validates_uniqueness_of :user_id
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "education", "experience", "id", "skill", "updated_at", "user_id"]
  end
end
