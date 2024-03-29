class QuestionsController < ApplicationController
    before_action :logged_in_user, only: [:index, :show, :filtered_questions, :submit_answers]
    before_action :check_admin_user, only: [:create, :destroy]
    def index
        page = params[:page].to_i.positive? ? params[:page].to_i : 1
        limit = params[:limit].to_i.positive? ? params[:limit].to_i : 100
    
        questions = Question.includes(:choices).limit(limit).offset((page - 1) * limit)
    
        total_questions = Question.count
        total_pages = (total_questions.to_f / limit).ceil
    
        if questions.empty?
        render json: {
            message: "Questions Not Found",
            questions: []
        }, status: :not_found
        else
        render json: {
            message: "Questions Retrived Successfully",
            current_page: page,
            total_pages: total_pages,
            record: "#{questions.count} questions in current page",
            total_questions: total_questions,
            questions: questions,
        }, status: :ok
        end
    end
      
    def show
        question = set_question
        if question
            render json: {
                message: "Question Found",
                question: question
            }, status: :ok
        else
            render json: {
                message: "Question Not Found",
                question: []
            }, status: :not_found
        end
    end

    def filtered_questions
        difficult = params[:difficult]
        lang = params[:lang]
        @questions = Question.where("language like ? AND level like ?","%#{lang}%","%#{difficult}%" ).order("RANDOM()").limit(25)
        if @questions.empty?
            render json: {
                message: "No Questions Found With the #{params[:difficult]} with #{params[:lang]}",
                question: []
            }, status: :not_found
        else
            render json:{
                message: "Questions Based on the #{params[:difficult]} and #{params[:lang]}",
                questions: @questions.as_json(only: [:id, :que], include: { choices: { only: [:id,:option] } }) 
            }, status: :ok
        end
    end

    def submit_answers
        submitted_answers = params[:answers]
      
        total_questions = 25
        correct_answers = 0
        incorrect_questions = []
      
        submitted_answers.each do |answer|
          question = Question.find(answer[:question_id])
          selected_option = Choice.find(answer[:option_id]) if answer[:option_id].present?
      
          if selected_option.present?
            if selected_option.option == question.correct_answer
              correct_answers += 1
            else
              incorrect_questions << {
                question_id: question.id,
                question: question.que,
                correct_answer: question.correct_answer,
                selected_option: selected_option.option
              }
            end
          else
            incorrect_questions << {
              question_id: question.id,
              question: question.que,
              correct_answer: question.correct_answer,
              selected_option: nil 
            }
          end
        end
      
        score = (correct_answers.to_f / total_questions) * 100
        # UserMailer.score_email(current_user, score).deliver_now if defined?(current_user)
      
        render json: { 
          message: "You Have Scored",
          score: score, 
          correct_answers: correct_answers, 
          total_questions: total_questions,
          incorrect_questions: incorrect_questions
        }
      end
      
      

    def create
        question = Question.create(question_params)
        if question.save
            render json: {
                message: "Question Created Successfully",
                question: question
            }, status: :created
        else
            render json: {
                message: "Question Unable to Create",
                error: question.errors.full_messages
            }, status: 422
        end
    end

    def update
        question = set_question
        if question.update(question_params)
            render json: {
                message: "Question Updated Successfully",
                question: question
            }, status: :ok
        else
            render json: {
                message: "Question Unable to Update",
                error: question.errors.full_messages
            }, status: 422
        end
    end

    private
    def question_params
        params.require(:question).permit(:que, :correct_answer, :level, :language)
    end

    def check_admin_user
        if logged_in_user.admin? 
            return logged_in_user
        else
            render json: { message: "Dude You Don't have permission"
             }, status: 401
        end
    end

    def set_question
        question = Question.find(params[:id])
        if question
            return question
        end
    end
end
