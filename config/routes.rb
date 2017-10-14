Rails.application.routes.draw do
  get 'pt/:id' => 'index#pt'
  get 'index/index'

  root 'index#index'
end
