Rails.application.routes.draw do
  root 'page#index'
  get 'page/index'
  devise_for :users do
  end
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  mount Nextbbs::Engine => "/nextbbs", as: "nextbbs"
end
