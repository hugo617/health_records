Rails.application.routes.draw do
  # 登录相关路由
  # 管理端登录路由
  get '/login', to: 'sessions#new', as: :admin_login
  post '/login', to: 'sessions#create'
  
  # 用户端登录路由
  get '/mobile_login', to: 'sessions#mobile_new', as: :mobile_login
  post '/mobile_login', to: 'sessions#mobile_login'
  
  # 通用登出路由
  delete '/logout', to: 'sessions#destroy', as: :logout
  
  # 验证码发送API
  post '/api/send_code', to: 'sessions#send_code'

  # 主页路由放在最后
  root to: 'home#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  get 'favicon.ico', to: 'application#favicon'

  resources :files, only: [:index, :show] do
    member do
      get :download
    end
  end

  resources :reports, only: [:index] do
    collection do
      post :search
    end
  end
end
