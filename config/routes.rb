Nextbbs::Engine.routes.draw do
  resources :topics do
    resources :comments
  end

  get 'shitaraba/', to: 'shitaraba#index'
  get 'shitaraba/index'
  get 'shitaraba/subject.txt', to: 'shitaraba#subject'
  get 'shitaraba/dat/:id', to: 'shitaraba#dat', default: :dat

end
