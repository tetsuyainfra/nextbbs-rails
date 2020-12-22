Nextbbs::Engine.routes.draw do
  root "page#index"
  get "test_flash", to: "page#test_flash"

  # resources :boards, trailing_slash: true do
  resources :boards, trailing_slash: true, constraints: Nextbbs::NotNichanBrowserConstraint do
    collection do
      get "yours"
    end
    member do
      get "control"
    end
    # resources :topics
    resources :topics, only: [:index, :show, :new, :create, :destroy]

    # if Nextbbs.config.compatible_2ch
    #   member do
    #     get 'SETTING.TXT',    to: 'nichan#setting', as: :nichan_setting
    #     get 'subject.txt',    to: 'nichan#subject', as: :nichan_subject
    #     get 'dat/:topic_id',  to: 'nichan#dat', default: :dat, as: :nichan_dat
    #   end
    #   collection do
    #     get  'test/read.cgi/:board_id/:topic_id/',  to: 'nichan#read_cgi', as: :nichan_read_cgi
    #     post 'test/bbs.cgi',                        to: 'nichan#bbs_cgi',  as: :nichan_bbs_cgi
    #   end
    # end
  end
  resources :comments, only: [:index, :show, :create, :destroy]

  if Nextbbs.config.compatible_2ch
    scope "boards", as: "" do
      get "/:board_id/", to: "nichan#board", format: false, as: :nichan_board
      get "/:board_id/SETTING.TXT", to: "nichan#setting", format: false, as: :nichan_setting
      get "/:board_id/subject.txt", to: "nichan#subject", format: false, as: :nichan_subject
      get "/:board_id/dat/:topic_id.dat", to: "nichan#dat", format: false, as: :nichan_dat
      get "/test/read.cgi/:board_id/:topic_id/(:query)", to: "nichan#read_cgi", format: false,
                                                         constraints: { query: /[0-9ln\-]+/ }, as: :nichan_read_cgi
      # constraints: { query: /l?(\d+)(\-)?(\d+)?n?/ }, as: :nichan_read_cgi
      post "/test/bbs.cgi", to: "nichan#bbs_cgi", as: :nichan_bbs_cgi
    end
  end

  # こういうのもあるらしい
  # get '/stories/:name', to: redirect {|params, req| "/posts/#{params[:name].pluralize}" }
  # resolve("Hoge") {}

  #   member do
  #     get 'SETTING.TXT',    to: 'nichan#setting', as: :nichan_setting
  #     get 'subject.txt',    to: 'nichan#subject', as: :nichan_subject
  #     get 'dat/:topic_id',  to: 'nichan#dat', default: :dat, as: :nichan_dat
  #   end
  #   collection do
  #     get  'test/read.cgi/:board_id/:topic_id/',  to: 'nichan#read_cgi', as: :nichan_read_cgi
  #     post 'test/bbs.cgi',                        to: 'nichan#bbs_cgi',  as: :nichan_bbs_cgi
  #   end
  # end
end

# # 2ch互換が先やね
# # /nextbbs/[:board_name]/SETTING.TXT
# get 'local/',            to: 'shitaraba#index'
# get 'local/SETTING.TXT', to: 'shitaraba#setting'
# get 'local/subject.txt', to: 'shitaraba#subject'
# get 'local/dat/:topic_id',     to: 'shitaraba#dat', default: :dat

# したらば互換は置いておく・・・
# /game/58589/subject.txt
# /game/58589/subject.txt
# /bbs/api/setting.cgi/[カテゴリ]/[番地]/
# /bbs/read.cgi/game/[掲示板番号]/[スレッド番号]/
# /bbs/rawmode.cgi/[カテゴリ]/[掲示板番号]/[スレッド番号]/[オプション]
# get 'shitaraba/', to: 'shitaraba#index'
# get 'shitaraba/subject.txt', to: 'shitaraba#subject'
# get 'shitaraba/dat/:id', to: 'shitaraba#dat', default: :dat
# post 'test/bbs.cgi', to: 'shitaraba#bbs'
# match 'test/bbs.cgi', to: 'shitaraba#bbs', via: [:get, :post]
# /bbs/api/setting.cgi/[カテゴリ]/[番地]/
# TOP=掲示板のURL
# DIR=カテゴリ
# BBS=番地
# CATEGORYカテゴリ名(日本語名)
# BBS_THREAD_STOP=１スレッドに書き込めるレスの上限数
# BBS_NONAME_NAME=名無しさんの名前
# BBS_DELETE_NAME=削除されたレスに付く名前(あぼーん名)
# BBS_TITLE=掲示板タイトル
# BBS_COMMENT=掲示板の説明文

# /bbs/rawmode.cgi/[カテゴリ]/[掲示板番号]/[スレッド番号]/[オプション]
# [オプション] : [N], [N]-, [N]-[M],l[N], [N]n
