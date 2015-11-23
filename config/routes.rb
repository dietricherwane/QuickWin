Rails.application.routes.draw do
  root 'messages#new'

  devise_for :users, :controllers => {:registrations => "users/registrations", :sessions => "users/sessions", :passwords => "users/passwords", :confirmations => "users/confirmations"}

  get 'subscribers/pmu' => 'subscribers#pmu', as: :pmu_subscribers
  get 'subscribers/loto_bonheur' => 'subscribers#loto_bonheur', as: :loto_bonheur_subscribers
  get 'subscribers/load_list' => 'subscribers#load_list', as: :subscribers_load_list
  post 'subscribers/load_excel_list' => 'subscribers#load_excel_list', as: :subscribers_load_excel_list

  get 'message' => 'messages#new', as: :message
  post 'message/send' => 'messages#send_message', as: :send_message
  get 'message/send' => 'messages#new'

  get 'transactions' => 'transactions#list', as: :transactions

  get 'message_logs/:transaction_id' => 'message_logs#list', as: :message_logs

  get 'search' => 'search#index', as: :search
  post 'search/perform' => 'search#perform', as: :perform_search
  get 'search/perform' => 'search#index'

  get '/9a9a03436c6aa13773a9d695beeaa8bc/sms_counter' => 'sms_counters#index', as: :sms_counter
  post 'sms_counter/update' => 'sms_counters#update', as: :update_sms_counter
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
  get '*rogue_url', :to => 'errors#routing'
  post '*rogue_url', :to => 'errors#routing'
end
