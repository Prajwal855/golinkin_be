class User < ApplicationRecord
  has_many :profiles
  has_many :companies
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  def jwt_payload
    super
  end

  enum role: { company: "company", jobseeker: "jobseeker", freelancer: "freelancer"}

  # validates :role, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["confirmation_sent_at", "confirmation_token", "confirmed_at", "created_at", "current_sign_in_at", "current_sign_in_ip", "email", "encrypted_password", "failed_attempts", "first_name", "gender", "id", "jti", "last_name", "last_sign_in_at", "last_sign_in_ip", "locked_at", "otp_verified", "phonenumber", "remember_created_at", "reset_password_sent_at", "reset_password_token", "role", "sign_in_count", "unconfirmed_email", "unlock_token", "updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["profiles"]
  end
end
