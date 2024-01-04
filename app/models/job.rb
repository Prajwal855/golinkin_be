class Job < ApplicationRecord
    belongs_to :company

    validates :position, :experience, presence: true
    validates :salary, numericality: { greater_than_or_equal_to: 0 }
    validates :company_id, presence: true, uniqueness: true
end
