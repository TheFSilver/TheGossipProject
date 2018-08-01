Rails.application.routes.draw do
  get '/', to: 'static_pages#home'
  get '/gossips/new', to: 'gossips#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
