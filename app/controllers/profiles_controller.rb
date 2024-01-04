class ProfilesController < ApplicationController
    before_action :current_log

    def show
        profile = set_profile
        if profile
            render json:{
                message: "Profile Found",
                profile: DocumentSerializer.new(profile)
            },status: :ok
        else
            render json: {
                message: "Profile Not Found",
                profile: []
            }, status: :not_found
        end
    end

    def create
        profile = Profile.create(profiles_params)
        if profile.save
            render json: {
                message: "Profile Created Successfully",
                profile: profile
            }, status: :created
        else
            render json: {
                message: "Profile Cannot be Created",
                profile: profile.errors.full_messages
            }, status: 422
        end
    end

    def update
        profile = set_profile
        if profile.update(profiles_params)
            render json: {
                message: "Profile Updated Successfully",
                profile: profile
            }, status: :ok
        else
            render json: {
                message: "Profile Unable to Upadte",
                error: profile.errors.full_messages
            }, status: 422
        end
    end

    private
    def set_profile
        profile = Profile.find_by(id: params[:id])
        if profile
            return profile
        end
    end

    def profiles_params
        params.permit(:skill,:experience,:education, :cv).merge(user_id: current_user.id)
    end

    def current_log
        jwt_payload = JWT.decode(request.headers['token'], ENV['secret_key_base']).first
        @current_user = User.find(jwt_payload['sub'])
        if @current_user
            return @current_user
        else
            render json: {
                message: "no Active Session for this current User"
            }, status: 401
        end
    end
end
