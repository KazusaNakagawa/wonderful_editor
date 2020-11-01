Rails.application.routes.draw do
  root to: "home#index"

  # TODO: ここが "api", "v1" では無い訳??
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        # token_validations: "api/v1/auht/token_validations",
        registrations: "api/v1/auth/registrations",
      }

      # REST API 紐付ける
      resources :articles
    end
  end
end
