Rails.application.routes.draw do
  resources :user_units
  resources :units
  # 1. Autenticação (Devise)
  devise_for :users

  # 2. Página Inicial (Cai direto nos Blocos ao logar)
  root "blocks#index"

  # 3. Recursos do Sistema (Telas de cadastro e listagem)
  resources :blocks do
    resources :units, only: [:index, :show] # Unidades dentro de cada bloco
  end

  resources :units # Para o Admin gerenciar unidades soltas
  
  resources :tickets do
    resources :comments, only: [:create] # Histórico de interações exigido 
  end

  resources :ticket_types # Onde o Admin define o SLA 
  resources :statuses    # Onde o Admin define os status 
  
  # Rota de saúde do app
  get "up" => "rails/health#show", as: :rails_health_check

  get "admin_dashboard", to: "static_pages#admin_dashboard"

end
