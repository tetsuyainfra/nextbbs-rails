Nextbbs::Engine.routes.draw do
  # resources :topics
  # resources :topics, only: [:index, :show, :edit, :new] do
  #   get 'destroy', on: :member
  # end
  resources :topics, except: [:destroy] do
    get 'destroy', on: :member
  end
end
