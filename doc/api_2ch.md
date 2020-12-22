# 2ch APIの概要

- 文字コード: Shift-JIS
- URL http://[HOST_NAME]/test/read.cgi/[BOARD_NAME]/[THREAD_ID]/
  ex:
    HOST_NAME: nextbbs.dev
    BOARD_NAME： testita
    THREAD_ID： 1000000000
- Janeでの動作
  1. 板追加: http://localhost:3000/nextbbs/boards/980190962
     板名取得 -> /nextbbs/boards/980190962/  HTTP/1.1
  2. スレッド一覧の更新
     /nextbbs/boards/980190962/subject.txt HTTP/1.1
  3. スレ取得
     /nextbbs/boards/980190962/dat/980190962.dat
  4. スレ更新
     /nextbbs/boards/980190962/dat/980190962.dat
  5. コメント書き込み
     /nextbbs/boards/test/bbs.cgi
     Parameters: {
       "submit"=>"\x8F\x91\x82\xAB\x8D\x9E\x82\xDE",
       "FROM"=>"",
       "mail"=>"sage",
       "MESSAGE"=>"\x82\xA0\x82\xA2\x82\xA4\x82\xA6\x82\xA8\x82\xA9\x82\xAB\x82\xAD\x82\xAF\x82\xB1",
       "bbs"=>"980190962",
       "key"=>"980190962",
       "time"=>"1607008623"
     }
     /nextbbs/boards/980190962/dat/1014017007.dat
     Parameters: {
       "submit"=>"\x8F\x91\x82\xAB\x8D\x9E\x82\xDE",
       "FROM"=>"",
       "mail"=>"sage",
       "MESSAGE"=>"\x82\xA0\x82\xA0\x82\xA0\x82\xA0",
       "bbs"=>"980190962",
       "key"=>"1014017007",
       "time"=>"1607008759"
     }
- DATのフォーマット
  2ch
  > 名前<>メール欄<>日付、ID<>本文<>スレタイトル(1行目のみ存在する)\n
  実データ
  > Socket774<>sage<>2014/12/27(土) 01:01:01.85 ID:XxxxX0xx<>[SPACE]Comment Body[SPACE]<>[SPACE]Thread Title
  > Socket774<>sage<>2014/12/27(土) 13:06:37.95 ID:ZsacW9wa<>[SPACE]Comment Body[SPACE]<>
  > Socket774<>sage<>2014/12/27(土) 13:07:41.14 ID:ZsacW9wa<>[SPACE]Comment Body[SPACE]<>

  shitaraba
  1<><font color="#FF9446">X</font><><>2020/11/29(日) 20:36:22<>Comment Body<>ThreadTitle<>ID?
  951<>Xさん<>sage<>2020/12/01(火) 00:00:00<>Comment Body<><>XxxxxxxxX
  952<>Xさん<>sage<>2020/12/01(火) 00:00:40<>Comment Body<><>Xxxxxxxx0
  953<>Xさん<>sage<>2020/12/01(火) 00:00:54<>Comment Body<><>Xxxxxxxx0
