Rails.application.routes.draw do
  post "recipe_imports", to: "recipe_imports#create"
  patch "recipe_ingredient_progresses/:recipe_ingredient_id", to: "recipe_ingredient_progresses#update", as: :recipe_ingredient_progress
  patch "step_progresses/:step_id", to: "step_progresses#update", as: :step_progress
  resources :recipe_ingredients
  resources :storages
  resources :adjustments
  resources :substitutes
  resources :substitutions
  resources :technique_notes
  resources :steps
  resources :ingredients
  resources :recipes
  root "recipes#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
