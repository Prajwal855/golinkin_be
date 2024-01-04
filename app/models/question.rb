class Question < ApplicationRecord
    has_many :choices, dependent: :destroy
    accepts_nested_attributes_for :choices, allow_destroy: true
  
    validates :level, :que, :correct_answer, presence: true
    enum level: { level1: "level1", level2: "level2", level3: "level3" }
  
    validates :language, presence: true
    enum language: { Ruby: "Ruby", ReactJS: "ReactJS", ReactNative: "ReactNative" , ManualQA: 'ManualQA'}
    def self.ransackable_associations(auth_object = nil)
        ["choices"]
      end

      def self.ransackable_attributes(auth_object = nil)
        ["correct_answer", "created_at", "id", "language", "level", "que", "updated_at"]
      end
end
