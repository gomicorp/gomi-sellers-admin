Rails.application.routes.draw do
  root 'hello#world' # example
  get 'sign_out', to: 'application#basic_auth_sign_out', as: :sign_out
end
