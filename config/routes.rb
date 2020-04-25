Nextbbs::Engine.routes.draw do
  root 'page#index'

  # resources :boards, trailing_slash: true do
  resources :boards do
    resources :topics
    member do
      get 'control'
    end

    if Nextbbs.config.compatible_2ch
      member do
        get 'SETTING.TXT',    to: 'nichan#setting'
        get 'subject.txt',    to: 'nichan#subject'
        get 'dat/:topic_id',  to: 'nichan#dat', default: :dat
      end
      collection do
        get  'test/read.cgi/:board_id/:topic_id/',  to: 'nichan#read_cgi'
        post 'test/bbs.cgi',                        to: 'nichan#bbs_cgi'
      end
    end
  end

  resources :comments, except: [:new]

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