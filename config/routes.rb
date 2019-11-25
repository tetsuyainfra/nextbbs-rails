Nextbbs::Engine.routes.draw do
  resources :topics do
    resources :comments
  end
end
