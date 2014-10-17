Rails.application.routes.draw do

  resources :challenges do
    resources :dares do
      member do
        put 'accept_challenge'
        put 'reject_challenge'
      end
      resources :votes
    end
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations" }
  # devise_scope :user do
  #   get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  # end


  get 'users/:id' => 'users#show', as: 'user'
  get 'users' => 'users#index', as: 'users'
  get 'dares_voting' => 'dares#show_voting', as: 'dares_voting'
  get 'notifications' => 'notifications#index'
  put 'challenges/:challenge_id/dares/:id/delete_proof/:proof_id' => 'dares#delete_proof', as: 'delete_proof'
  put 'challenges/:challenge_id/dares/:id/accept_proof' =>  'dares#accept_proof', as: 'accept_proof'
  put 'challenges/:challenge_id/dares/:id/reject_proof' =>  'dares#reject_proof', as: 'reject_proof'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  get '/' => 'challenges#intro', as: 'intro'
  root 'challenges#intro'



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
