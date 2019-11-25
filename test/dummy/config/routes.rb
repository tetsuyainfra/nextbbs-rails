Rails.application.routes.draw do
  root 'page#index'
  get 'page/index'
  mount Nextbbs::Engine => "/nextbbs", as: "nextbbs"
end
