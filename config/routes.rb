Rails.application.routes.draw do
  resources :rooms
  resources :hotels
  devise_for :users, skip: 'registrations', controllers: {
    sessions: 'users/sessions'
  }
  get 'cid/:access_key', to: 'home#index'
  get '/submit', to: 'home#submit'
  get '/download_report/:date', to: 'home#download_report'
  root to: "home#index"
  match '*unmatched', to: 'application#route_not_found', via: :all
end
