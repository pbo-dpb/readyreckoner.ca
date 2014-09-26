Rails.application.routes.draw do
  root to: 'pages#index'
  post '/print', to: 'pages#print', as: :print
  mount CitizenBudgetModel::Engine => '/'
end
