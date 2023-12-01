Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  get 'download_sample', to: 'home#download_sample'

  resources :student_records do
    collection do
      post :import
      delete 'destroy_all', to: 'student_records#destroy_all'
    end
  end
end
