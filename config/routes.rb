Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  devise_scope :user do
	  get 'sign_in', to: 'user/sessions#new'
	  post 'sign_in', to: 'user/sessions#create'
    post 'sign_out', to: 'users/sessions#destroy'
	  post 'change_password', to: 'users/sessions#change_password'
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
end
