Nextbbs::Engine.routes.draw do
  resources :topics do
    resources :comments
  end

  get 'shitaraba/', to: 'shitaraba#index'
  get 'shitaraba/index'
  get 'shitaraba/subject.txt', to: 'shitaraba#subject'
  get 'shitaraba/dat/:id', to: 'shitaraba#dat', default: :dat
  # post 'test/bbs.cgi', to: 'shitaraba#bbs'
  match 'test/bbs.cgi', to: 'shitaraba#bbs', via: [:get, :post]

end
