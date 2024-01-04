# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json
  
  def respond_with(resource, _opts = {})
    token = request.env['warden-jwt_auth.token']
    if @user && @user.valid_password?(params[:user][:password]) && @user.otp_verified == true
      render json: {
        status: {code: 200, message: 'Logged in sucessfully.'},
        meta: {
          token: token
        }
      }, status: :ok
    else
      render json: { message: 'Invalid credentials or Account Not Exist or OTP Not Verified' }, status: :unauthorized
  end
end
end
