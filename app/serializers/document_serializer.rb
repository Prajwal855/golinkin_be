class DocumentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :skill,:experiance, :user_id

  attribute :cv do |resume|
    if resume.cv.present?
      host = Rails.env.development? ? 'http://localhost:3000' : ENV["BASE_URL"]
      host + Rails.application.routes.url_helpers.rails_blob_url(resume.cv,only_path: true)
    end
  end

  attribute :photo do |photos|
    if photos.photo.present?
      host = Rails.env.development? ? 'http://localhost:3000' : ENV["BASE_URL"]
      host + Rails.application.routes.url_helpers.rails_blob_url(photos.photo,only_path: true)
    end
  end
end
