Rails.application.routes.draw do
  #post "/users", to: "users#create"
  get "/me", to: "users#me"
  post "/auth/login", to: "users#login"
  post "/auth/logout", to: "users#logout"
  resource :users
end
