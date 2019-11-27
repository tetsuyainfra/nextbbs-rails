Nextbbs::Engine.routes.draw do
  get 'shitaraba/index'
  get 'shitaraba/dat'
  resources :topics do
    resources :comments
  end
end
