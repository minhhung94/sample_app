Rails.application.routes.draw do
  resources :users
  scope "(:locale)", locale: /en|vi/ do
	get 'users/new'
	get 'static_pages/home'
  end
end
