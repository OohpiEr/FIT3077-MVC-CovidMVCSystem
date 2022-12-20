Rails.application.routes.draw do
  get 'testing_site_bookings/index'
  get 'search_booking/index'
  get 'profile/index'
  get 'profile/show', to: 'profile#show'
  get 'profile/modify', to: 'profile#modify'
  get 'profile/cancel', to: 'profile#cancel'
  get 'profile/undo', to: 'profile#undo'
  get 'scan_qr/index'
  get 'create_home_booking/index'
  get 'interview_form/index'
  get 'search_booking/index'
  get 'create_booking/index'
  get 'search_testing_site/index'
  get 'home/index'
  get 'session/index'
  get 'login/index'
  get 'search_booking/search'
  get 'testing_site_bookings/delete', to: 'testing_site_bookings#delete'
  get 'testing_site_bookings/cancel', to: 'testing_site_bookings#cancel'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Defines the root path route ("/")
  # root "articles#index"
  
  root 'login#index'
  post 'login/index', to: 'session#create'
  post 'search_testing_site/index', to: 'search_testing_site#search'
  post 'create_booking/index', to: 'create_booking#create'
  post 'create_home_booking/index', to: 'create_home_booking#create'
  post 'scan_qr/index', to: 'scan_qr#scan_qr'
  post 'search_booking/search', to: 'search_booking#search'
  post 'interview_form/index', to: 'interview_form#submit'
  post 'profile/modify', to: 'profile#submit'
#   post 'profile/undo'
end
