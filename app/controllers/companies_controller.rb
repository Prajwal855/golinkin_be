class CompaniesController < ApplicationController
    before_action :current_log

    def index
        companies = Company.all
        if companies.empty?
            render json: {
                message: "Company Not Found"
            }, status: :not_found
        else
            render json: {
                message: "Company Found",
                companies: [companies]
            }, status: :ok
        end        
    end

    def show
        company = set_company
        if company
            render json:{
                message: "Company Found",
                company: DocumentSerializer.new(company)
            },status: :ok
        else
            render json: {
                message: "Company Not Found for given Id",
                company: []
            }, status: :not_found
        end
    end

    def create
        if current_user.role = 'company'
            company = Company.create(company_params)
            if company.save
                render json: {
                    message: "Company Created Successfully",
                    company: company
                }, status: :created
            else
                render json: {
                    message: "Company Cannot be Created",
                    company: company.errors.full_messages
                }, status: 422
            end
        else
            render json: {
                message: "Dude Your role should be Company"
            },status: 401
        end
    end

    def update
        company = set_company
        if company.update(company_params)
            render json: {
                message: "Company Updated Successfully",
                company: company
            }, status: :ok
        else
            render json: {
                message: "Company Unable to Upadte",
                error: company.errors.full_messages
            }, status: 422
        end
    end


    def destroy
        company = set_company
        if company.present?
            company.delete
            render json:
            {
                message: "Specified company Id deleted successfully...",
                company: company
            }, status: 200
        else
            render json:
            {
                message: "Sorry!,specified company Id failed to delete!!!"
            }, status: 400
        end
    end

    private
    def set_company
        company = Company.find_by(id: params[:id])
        if company
            return company
        end
    end

    def company_params
        params.permit(:name,:company_type,:size, :website,:founded,:headquarters,:specialities).merge(user_id: current_user.id)
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
