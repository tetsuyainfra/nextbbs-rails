---
title: Nextbbsとは
---

## 開発者向け情報

### 基本事項

Nextbbs はトピック形式の掲示板の基本操作をまとめた rails 用マウンタブルエンジンです。
このエンジンをマウントして、アプリ開発者がカスタマイズして使えるように作成したいと考えています。

実際に運用している Rails アプリのソースは [nextbbs](https://github.com/tetsuyainfra/nextbbs) になる**予定**でそちらを参照してくれるとうれしいです。

### データモデルの概要

Nextbbs におけるデータモデルはシンプルで掲示板、トピック、コメントを関連付けたものです。
> 2chでの掲示板、スレッド、レスに相当

- 掲示板モデルにはタイトル、詳細テキストのみが含まれます。
- トピックモデルにはタイトル、レス数が含まれます。
- コメントモデルには 書き込み者の名前、メールアドレス、本文、ID に加え、meta カラムが含まれます。
  ※ Rails 標準で作られるカラムが流用できるときはそのまま使っています。

詳細なモデルはこちらで見ることができます。

### 認証(AuthN)の管理

ユーザーの認証（ログイン・セッションとユーザの関連付け）は本gem外にて実装すると想定しています。
> devise等
このMountable Engineのコントローラー内ではUserモデルの取得には_current_userメソッドを使っています。
_current_user内部でdeviseなどのcurrent_userメソッドを呼び出すことでUserモデルを返します。

### 認可(AuthZ)の管理

認可の実装は本gem内に一応用意していますが、アプリケーションとの連携を考えると外部gemが使える方が良いと思います。
> CanCanCan, pundit等
そこで認可を外部で行える仕組みとしてNextbbsApplicationControllerでのメソッド呼び出し、各コントローラーのアクションでの呼び出しを
ラップできる関数(変数)を用意しています。
もしくはコントローラーのオーバーライド(Railsのクラス検索とロード順)を使って実装します。
パラメータがポストされてアクションが実行されるまでのフローは次の通りです

### 書き込みのフローチャート

HTTPリクエストはRackの処理プロセスを通過した後、

```plantuml
(*) --> [HTTP request] "Rack Middlewares
....
etc..
run MyApp::Application.routes" as route

partition "正常フロー" {
route --> "認証チェック" as AuthN
AuthN --> "認可チェック" as AuthZ

AuthZ --> "Action method" as Action
}

Action -down-> [return Http Response] (*)

AuthN -right-> "例外処理:認証" as RaiseAuthN
AuthZ -right-> "例外処理:認可" as RaiseAuthZ
Action -right-> "例外処理:アクション" as RaiseAction

```


### バッチ処理


### 今後の実装予定

- Devise
- SwagerAPI
- 過去ログ化のサポート
- BBS の構造化
  - Model のテスト作成
    - Board Model
    - 改行を含むタイトルをどうするか
    - Comment Model 修正
  - コントローラーのテスト作成
    - Board
    - Topic
    - Comment
      - あぼーん
  - リファクタリング
    - Shitaraba 互換のコントローラー化 -> Nichan 互換に変更
  - 機能追加
    - 初回アクセス時の掲示板自動作成
      Form 用意しておいて、上書きできるようにするのが一番では？
    - ID 機能とか
    - キャップ機能とか
    - NG, BAN
    - 掲示板カスタマイズ
    - 掲示板番号以外でのアクセスカスタマイズ方法(username など)
  - View のカスタマイズ機能
    - ユーザ
    - アドミン
- DB インデックス最適化の考察
  - ログ整理するなら created_at の解析必要ない可能性

<!--
# 一般利用者の方へ
## 書き込みの仕方
## ユーザ登録の方法
## ツール等の利用方法

# 掲示板管理者の方へ
## ユーザ登録の方法
## 掲示板の開設方法
## 掲示板の管理方法

# 掲示板設置者(サーバー管理者)の方へ
## サーバー管理者の登録方法
## ユーザ管理の方法(掲示板管理者の管理も含む)
## バッチ処理について
-->
