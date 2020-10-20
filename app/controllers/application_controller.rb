class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # CSRF 対策を OFF
  protect_from_forgery with: :null_session
end
