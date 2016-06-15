Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'fetch_cricinfo_data#index'
  resources :users do
  	member do
  		get 'enter_meaning'
  		get 'show_meaning_data'
  	end
  end
end
