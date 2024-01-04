Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # Custom routes for questions
  get 'getquestion', to: 'questions#filtered_questions'
  post 'submitanswer', to: 'questions#submit_answers'

  get 'user', to: 'users#show'
   # SMS verification endpoint
   post 'users/sms_confirmation', to: 'accounts#sms_confirm'
   resources :profiles,:choices,:questions,:termsandconditions, :companies
  
  get 'get_roles', to: 'users#get_roles'

  resources :companies
  resources :jobs

   
end
