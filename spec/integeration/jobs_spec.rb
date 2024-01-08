require 'swagger_helper'

describe 'Jobs API' do

  path '/api/v1/jobs' do

    get 'Retrieves all jobs' do
      tags 'Jobs'
      produces 'application/json'
      
      response '200', 'jobs found' do
        let(:job) { create(:job) }
        run_test!
      end

      response '404', 'no jobs found' do
        let(:job) { [] }
        run_test!
      end
    end

    post 'Creates a job' do
      tags 'Jobs'
      consumes 'application/json'
      parameter name: :job, in: :body, schema: {
        type: :object,
        properties: {
          company_id: { type: :integer },
          position: { type: :string },
          experience: { type: :integer },
          salary: { type: :integer },
          skills_required: { type: :string },
          small_description: { type: :string }
        },
        required: [ 'company_id', 'position', 'experience', 'salary', 'skills_required', 'small_description' ]
      }

      response '201', 'job created' do
        let(:job) { attributes_for(:job) }
        run_test!
      end

      response '400', 'invalid request' do
        let(:job) { { position: 'developer' } }
        run_test!
      end
    end
  end

  path '/api/v1/jobs/{id}' do

    get 'Retrieves a job' do
      tags 'Jobs'
      produces 'application/json'
      parameter name: :id, :in => :path, :type => :string

      response '200', 'job found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            company_id: { type: :integer },
            position: { type: :string },
            experience: { type: :integer },
            salary: { type: :integer },
            skills_required: { type: :string },
            small_description: { type: :string }
          },
          required: [ 'id', 'company_id', 'position', 'experience', 'salary', 'skills_required', 'small_description' ]

        let(:id) { create(:job).id }
        run_test!
      end

      response '404', 'job not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a job' do
      tags 'Jobs'
      consumes 'application/json'
      parameter name: :id, :in => :path, :type => :string
      parameter name: :job, in: :body, schema: {
        type: :object,
        properties: {
          company_id: { type: :integer },
          position: { type: :string },
          experience: { type: :integer },
          salary: { type: :integer },
          skills_required: { type: :string },
          small_description: { type: :string }
        },
        required: [ 'company_id', 'position', 'experience', 'salary', 'skills_required', 'small_description' ]
      }

      response '200', 'job updated' do
        let(:id) { create(:job).id }
        let(:job) { { position: 'senior developer' } }
        run_test!
      end

      response '400', 'invalid request' do
        let(:id) { 'invalid' }
        let(:job) { { position: 'senior developer' } }
        run_test!
      end
    end

    delete 'Deletes a job' do
      tags 'Jobs'
      parameter name: :id, :in => :path, :type => :string

      response '200', 'job deleted' do
        let(:id) { create(:job).id }
        run_test!
      end

      response '400', 'invalid request' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
