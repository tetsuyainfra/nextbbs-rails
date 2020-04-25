# Board,Topic,Comment の管理

アプリケーション側でユーザモデルを作成
Nextbbs 内のモデルと関連付けする

- Board のオーナー(管理代表)は必ず一人
- 規模が大きくなるとサポーターが欲しいよね

## 案 1 OwnerId で示す

```plantuml
package "Nextbbs" {
class Board {
  id
  owner_id
}
}

class User {
  id
}

Board |o-r-|{ User

```

## 案 2 中間テーブル案

```plantuml
package "Nextbbs" {
class Board {
  id
}
}

class User {
  id
}

class UserNextbbsBoard {
  user_id
  nextbbs_board_id
}


Board ||-r-|{ UserNextbbsBoard
UserNextbbsBoard }o-r-|| User
```

## 案 1 ＋案２

```plantuml
package "Nextbbs" {
class Board {
  id
  owner_id
}
}

class User {
  id
}

class Role {
  user_id
  nextbbs_board_id
---
  role_type
}


Board ||-r-|{ Role
Role }o-r-|| User
Board |o-r-|| User
```
