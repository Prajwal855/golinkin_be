class Company < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :jobs, dependent: :destroy
end
