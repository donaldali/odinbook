Rails.application.routes.draw do

  devise_scope :user do
    root 'registrations#new'
  end

  devise_for :users, 
             :controllers => { :registrations => "registrations",
                               :omniauth_callbacks => "omniauth_callbacks" },
             :skip => [:sessions]
  as :user do
    get    'login'  => 'devise/sessions#new',     :as => :new_user_session
    post   'login'  => 'devise/sessions#create',  :as => :user_session
    delete 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
    get    'signup' => 'registrations#new'
  end

  resources :users,         only: [:index]
  resources :friendships,   only: [:create, :update, :destroy]
  resources :notifications, only: [:index]
  resources :posts,         only: [:create, :destroy]
  resources :comments,      only: [:create, :destroy]
  resources :likes,         only: [:create, :destroy]
  resources :profiles,      only: [:show, :edit, :update]

  get 'newsfeed/:id',        to: 'users#newsfeed',        as: :newsfeed
  get 'newsfeed/:id',        to: 'users#newsfeed',        as: :user_root
  get 'timeline/:id',        to: 'users#timeline',        as: :timeline
  get 'friends/:id',         to: 'users#friends',         as: :friends
  get 'friend_requests/:id', to: 'users#friend_requests', as: :friend_requests
  get 'find_friends/:id',    to: 'users#find_friends',    as: :find_friends

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
