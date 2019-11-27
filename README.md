# Nextbbs

Short description and motivation.

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

- Devise
- SwagerAPI
- BBSの構造化
  - Board Model
  - Comment Model 修正
  - ID機能とか
  - キャップ機能とか
  - NG, BAN
  - Shitaraba互換のコントローラー化
  - Viewのカスタマイズ機能
    - ユーザ
    - アドミン

