class TermsandconditionsController < ApplicationController
    def show
        termsandcondition = set_termsandcondition
        if termsandcondition
            render json: {
                message: "Terms and Condition Found",
                termsandcondition: termsandcondition.as_json(only: [:id, :name])
            }, status: :ok
        else
            render json: {
                message: "Terms and Condition Not Found",
                termsandcondition: []
            }, status: :not_found
        end
    end

    private
    def set_termsandcondition
        termsandcondition = Termsandcondition.find(params[:id])
        if termsandcondition
            return termsandcondition
        end
    end
end
