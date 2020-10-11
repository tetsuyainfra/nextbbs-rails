# DB の timezone を確認する

```shell
$ docker exec -it postgresql /bin/bash
# psql
#psql> show timezone;
```

# Sequenced の Conccurent-safe

- default では PostgreSQL でのみスレッドセーフ
  - DB に index 張って、トリガー使うとよろしいらしい＠詳細は Sequenced の README 参照
- 重くなりそうだけど読み込みはキャッシュで行われると想定してとりあえずこのままやってみる
  - ActiveRecord だけの環境作ってベンチマークとる
    - with_lock block 使う
    - SQL のトリガー使えない？
    - PostgreSQL だけサポートにして BigSerial 型を使う
