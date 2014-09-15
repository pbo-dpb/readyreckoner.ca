Rails.application.routes.draw do
  mount CitizenBudgetModel::Engine => '/'
end
