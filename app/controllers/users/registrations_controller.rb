# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  def respond_with(resource,opt={})
      build_resource(sign_up_params)
        if resource.valid?
            resource.save
            Twilio::SmsServise.new(to: resource.phonenumber, pin: '').send_otp
            token = request.env['warden-jwt_auth.token']
            render json: {
              status: {code: 200, message: 'Signed up sucessfully.', token: token},
              meta: resource.as_json(only: [:id, :email, :role]),
            }
        else
          render json: {
            status: {message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
          }, status: :unprocessable_entity
        end
    rescue ArgumentError => e
        render json: { error: e.message }, status: :unprocessable_entity
  end

  def sign_up_params
      params.require(:user).permit(:email, :first_name,:last_name, :password, :role, :phonenumber)
  end
end
