class JobsController < ApplicationController
    before_action :current_log


    def index
        job = Job.all
        if job.any?
            render json:
            {
                message: "Successfully fetched all job details",
                job_profiles: [job]
            }, status: 200
        else
            render json:
            {
                message: "NO jobs found"
            }, status: 404
        end
    end


    def show
        job = set_jobs
        if job
            render json:
            {
                message: "Found job details of specified ID",
                job: job
            }, status: 200
        else
            render json:
            {
                message: "Details not found for given ID"
            }, status: 404
        end
    end

  
    def create
        job = Job.create(job_params)
        if job.save
            render json:
            {
                message: "Details created successfully!",
                job: job
            }, status: 201
        else
            render json:
            {
                message: "Failed to create job details!",
                error: [job.errors.full_messages]
            }, status: 400
        end
    end



    def update
        job = set_jobs
        if job.update(job_params)
            render json:
            {
                message: "Specified Job Id details updated successfully",
                job: job
            }, status: 200
        else
            render json:
            {
                message: "Sorry!,specified JOb Id details failed to update!!!"
            }, status: 400
        end
    end



    def destroy
        job = set_jobs
        if job.present?
            job.delete
            render json:
            {
                message: "Specified Job Id deleted successfully...",
                job: job
            }, status: 200
        else
            render json:
            {
                message: "Sorry!,specified Job Id failed to delete!!!"
            }, status: 400
        end
    end
  
    private
  
    def set_jobs
      jobs = Job.find_by(id: params[:id])
      if jobs
        return job
      end
    end
  
    def job_params
      params.permit(:company_id, :position, :experience, :salary, :skills_required, :small_description)
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
  