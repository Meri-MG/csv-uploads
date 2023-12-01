Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  resources :student_records do
    collection do
      post :import
      delete 'destroy_all', to: 'student_records#destroy_all'
      get 'download_sample', to: 'student_records#download_sample'
    end
  end
end
