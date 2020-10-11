# DB の timezone を確認する

```shell
$ docker exec -it postgresql /bin/bash
# psql
#psql> show timezone;
```

# Sequenced の Conccurent-safe

- default では PostgreSQL でのみスレッドセーフ
  - DB に index 張って、トリガー使うとよろしいらしい＠詳細は Sequenced の README 参照
