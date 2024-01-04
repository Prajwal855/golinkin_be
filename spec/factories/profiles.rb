FactoryBot.define do
  factory :profile do
    date_of_birth { "2024-01-02 17:25:53" }
    skill { "MyString" }
    experience { "MyString" }
    education { "MyString" }
    user { nil }
  end
end
