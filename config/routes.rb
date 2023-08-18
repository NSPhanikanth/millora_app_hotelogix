Rails.application.routes.draw do
  devise_for :users, skip: 'registrations', controllers: {
    sessions: 'users/sessions'
  }
  root to: "home#index"
end
