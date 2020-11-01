Rails.application.routes.draw do
  get ".well-known/acme-challenge/:id" => "letsencrypt#index"
  get 'ajax/search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'calc#index'
end
