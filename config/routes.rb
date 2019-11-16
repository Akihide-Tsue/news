Rails.application.routes.draw do
  root 'posts#index'
  get 'posts', to: 'posts#index'
  get '/sub.html', to: 'posts#show'

end
