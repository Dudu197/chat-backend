Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
  	namespace :v1 do
  		post '/user/create', to: 'user#create'
  		post '/user/login', to: 'user#login'

  		post '/message/send', to: 'message#send_message'
  	end
  end
end
