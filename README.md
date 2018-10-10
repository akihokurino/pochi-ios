# pochi-ios
Pochi サービスの iOS クライアント

# Environment
* Xcode 8.1
* Ruby 2.2.2 (rbenv)

# setup
## Ruby のインストール
rbenv を使って Environment に記載の Ruby をインストールする

http://blog.sojiro.me/blog/2016/03/05/management-ruby-versions-by-rbenv/

## Ruby Gem のインストール
```bash
$ gem install bundler
$ bundle install
```

## xcproj のインストール
http://qiita.com/masaki925/items/878ab05824b772d72da9

```bash
$ brew install xcproj
```

Xcode をアップデートしたら
```bash
brew uninstall xcproj
brew install xcproj
```

## CocoaPods のインストール
```bash
$ bundle exec pod install
```
