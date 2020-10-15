Rails.application.routes.draw do
  # TODO: ここが "api", "v1" では無い訳??
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth"
      resources :articles
    end
  end
end
