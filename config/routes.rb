Rails.application.routes.draw do
  root 'posts#index'
  resources :posts, only: [:index, :show]
    get '/sub.html', to: 'posts#show';
    get 'about', to: 'posts#about';
    post '/mail', to: 'posts#mail', as: :mail;
end
