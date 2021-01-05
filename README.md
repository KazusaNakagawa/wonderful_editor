## About

- [WondfulEditor](https://k-wonderful-editor.herokuapp.com): 記事作成アプリ

### デモの流れ

- 新規登録 > 下書き記事作成 > 一覧で確認 > 投稿 > ログアウト > 一覧から記事確認

![demo_video](https://user-images.githubusercontent.com/34918376/103399589-13366e80-4b85-11eb-8a59-72a3e5126a3e.gif)

## 動作環境

- ruby 2.7.1
- Rails 6.0.3.3
- Vue.js: 2.6.11
- DB: PostgreSQL

## 主な使用 Gem

- active_model_serializers
- devise_token_auth
- rubocop-rails, rubocop-rspec
- annotate
- pry-byebug, pry-rails, pry-doc

## 実装機能

- 記事一覧機能(トップページ)
- 記事 CRUD (一覧以外)
- ユーザー登録・サインイン/サインアウト
- 記事の下書き機能
- マイページ（自分が書いた記事の一覧）

## 今後追加する機能

- 記事の検索機能
- (記事への) コメント機能(CRUD)
- (記事への) いいね機能
- メール通知
- ユーザーのアイコン画像
- レスポンシブ対応

## 苦労した点

### devise_token_auth

- トークン形式でユーザー認証を実装する流れは試行錯誤できた
- `devise` から継承して使われている流れも勉強になった
- 公式リファレンスを読みときながら実装方法を調べること

## 学んだ点

- 実装すべき機能をイメージできていないとそもそも実装できない
- Gem の扱い方：Github にある説明を読み解き、実装していく流れ
- `active_model_serializers`を使用し、必要な項目のみを JSON 形式で返すことができること
- **Rspec** を使用したテスト実装
- **endpoint** を意識して実装
- version 管理

## 今後に向けて

- サービスとして運用できるアプリ作成
- 本番環境にデプロイ
