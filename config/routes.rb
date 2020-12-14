Rails.application.routes.draw do
  root to: "home#index"

  # reload 対策
  get "sign_up", to: "home#index"
  get "sign_in", to: "home#index"
  get "articles/new", to: "home#index"
  get "articles/draft", to: "home#index"
  get "articles/drafts/:id/edit", to: "home#index"
  get "articles/:id/edit", to: "home#index"
  get "articles/:id", to: "home#index"
  get "mypage", to: "home#index"

  namespace :api do
    namespace :v1 do
      # 既存のクラスをorverrideで使う. 再発明しない
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations",
        sessions: "api/v1/auth/sessions",
      }

      namespace :articles do
        resources :drafts, only: [:index, :show]
      end

      namespace :current do
        resources :articles, only: [:index]
      end

      # REST API 紐付ける
      resources :articles
    end
  end
end
