Rails.application.routes.draw do
  root 'locations#index'

  get '/locations/search'
  resources :locations, param: :uuid, only: [:index, :create, :destroy, :show]

  get '/locations/:uuid/forecast', param: :uuid, to: 'forecasts#show', as: 'location_forecast'

end
