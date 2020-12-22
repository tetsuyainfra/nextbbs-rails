# Nextbbs

2ch 風スレッドフローティング掲示板を意識した
アプリに組み込みやすい Rails マウンタブルエンジン

## Usage

How to use my plugin.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nextbbs'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install nextbbs
```

## Settings

### I18n

Nextbbs sees I18n settings.for example, DAT log structure in Shitaraba like bbs.
You should change default_locale in config/application.rb

```
# default (no settings or en)
Name<>email<>2019/11/25(Mon) 13:50:16<>MyText<>
                        ~~~
# config.i18n.default_locale = :ja
Name<>email<>2019/11/25(月) 13:50:16<>MyText<>
                        ~~~
```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## TODO
- [x] コメント書き込み後のリダイレクト
- [x] コメントNOのNOT NULL化
- [x] コメント番号1スタート リミット制限の確認
- [x] 2chビューワ対応
  - [x] コメント標準部のエスケープ確認 (ERBでは %= ならHTMLエスケープは自動で行われる)
- [ ] リリース
  - [ ] ユーザー登録付きリリース(twitter認証)
  - [ ] 掲示板だけリリース

- [ ] キャッシュの設定しやすいようにURLで設定画面を分ける
- [ ] 掲示板登録画面
  - [] 作成後のリダイレクト
    - [] HTML
    - [x] JS
  - [] 編集 Form の URL
  - [] 編集 Form の Submit 文字列の書き換え
  - [] ユーザ権限の検討
  - [] テスト
  - [] 掲示板作成数の制限
  - [ ] コメント部分の差し替えメソッドをhelperに移動したい（DATとViewで使う）
        NullObjectのような実装にする？(ベンチ取る？)
- テストを作る
  - [ ] モデル
  - [ ] コントローラー
  - [ ] CSV,XSL を利用したテスト（特にパーミッション関係）
- レイアウト調整
  - [ ] モバイル表示時に各掲示板トップのポスト数表示を小さくする
  - [ ] 2ch 風レイアウトの追加
- [ ] 多言語対応
  - [ ] 時間表示
  - [ ] UI
- [ ] 追加機能
  - [ ] dummy app に Post コントローラーを作って、掲示板を読み込めるようにする
  - [ ] 画像投稿機能
  - [ ] 引用機能
  - [ ] 過去ログ機能
  - [ ] 次スレ作成機能
  - [ ] 掲示板読み込み機能
  - [ ] WebSocket 対応
  - [ ] Ban User List
  - [ ] Ban IP List
  - [ ] ユーザー機能をスコープ(/user)以下にまとめる
    - [ ] ツールバーの React 化
    - [ ] プロキシによるキャッシュを有効にする
  - [ ] Nextbbs::Comment.columns_hash['sequential_id'].limit から書き込み上限をチェックする機能をつける？

## 参考

- RailsAdmin
- https://gist.github.com/dhh/782fb925b57450da28c1e15656779556

## MEMO

- Thredded
- Stateman vs AASM
  - Stateman-diagram あるしこっち？
- rails こまんどあるある
  - rails db:migrate:reset
  - rails db:fixtures:load
  - rails app::annotate_models
  - rails app::annotate_routes
- rails console での挙動
  - app.nextbbs.root_path
  - app.nextbbs.board_path,

## 参考文献

- [と～く２ちゃんねる - Talk 2ch](http://age.s22.xrea.com/talk2ch/)
- [専ブラ開発への道 - プログラミングスレまとめ in VIP](http://vipprog.net/wiki/%E5%B0%82%E3%83%96%E3%83%A9%E9%96%8B%E7%99%BA%E3%81%B8%E3%81%AE%E9%81%93.html)
- [専用ブラウザ開発者様へのお知らせ｜したらば掲示板　開発日誌](http://blog.livedoor.jp/bbsnews/archives/50283526.html)
- [掲示板情報を取得する為の API を公開｜したらば掲示板　開発日誌](http://blog.livedoor.jp/bbsnews/archives/51024405.html)
- [Monazilla/develop/shitaraba - ５ちゃんねる wiki](https://info.5ch.net/index.php/Monazilla/develop/shitaraba)
- [SETTING.TXT - ５ちゃんねる wiki](https://info.5ch.net/index.php/SETTING.TXT)
- [Patterns for Successful Rails Engines - Ruby on Rails - Medium](https://medium.com/ruby-on-rails/patterns-for-successful-rails-engines-a7dae3db6921)
  - "".constantize で文字列からコントローラー(クラス）を指定できるぞ
- [accepts_nested_attributes_for を使わず、複数の子レコードを保存する
  ](https://moneyforward.com/engineers_blog/2018/12/15/formobject/)
