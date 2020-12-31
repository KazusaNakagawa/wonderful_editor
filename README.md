## About
* WondfulEditor : 記事作成アプリ

### デモの流れ
 * 新規登録 > 下書き記事作成 > 一覧で確認 > 投稿 > ログアウト
 
![demo_video](https://github.com/KazusaNakagawa/wonderful_editor/issues/98#issue-776820037)

## 動作環境
* ruby  2.7.1
* Rails 6.0.3.3
* Vue.js: 2.6.11
* DB: PostgreSQL

## 起動コマンド

```bash
$ bundle exec rails s
$ bin/webpack-dev-server
```

## 主な使用Gem

* active_model_serializers
* devise_token_auth
* rubocop-rails, rubocop-rspec
* annotate
* pry-byebug, pry-rails, pry-doc

## 実装機能

* 記事一覧機能(トップページ)
* 記事CRUD (一覧以外)
* ユーザー登録・サインイン/サインアウト
* 記事の下書き機能
* マイページ（自分が書いた記事の一覧）

## 今後追加する機能

* 記事の検索機能
* (記事への) コメント機能(CRUD)
* (記事への) いいね機能
* メール通知
* ユーザーのアイコン画像
* レスポンシブ対応

## 苦労した点

* `devise_token_auth`
 - トークン形式でユーザー認証を実装する流れは試行錯誤できた
 - `devise` から継承して使われている流れも勉強になった
 - 公式リファレンスを読みときながら実装方法を調べること

## 学んだ点
 - 実装すべき機能をイメージできていないとそもそも実装できない
 - Gemの扱い方：Githubにある説明を読み解き、実装していく流れ
 - `active_model_serializers`を使用し、必要な項目のみをJSON形式で返すことができること
 - **Rspec** を使用したテスト実装
 - **endpoint** を意識して実装
 - version 管理

## 今後に向けて
 - サービスとして運用できるアプリ作成
 - 本番環境にデプロイ
