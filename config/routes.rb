Rails.application.routes.draw do
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'fetch_cricinfo_data#index'
  get 'users/enter_meaning' => 'users#enter_meaning'
  get 'users/show_meaning_data' => 'users#show_meaning_data'
end
