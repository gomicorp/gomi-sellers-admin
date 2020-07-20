Rails.application.routes.draw do
  get 'sign_out', to: 'application#basic_auth_sign_out', as: :sign_out
  ActiveAdmin.routes(self)

  resources :seller_infos
end
