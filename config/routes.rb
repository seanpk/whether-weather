Rails.application.routes.draw do
  root 'locations#index'
  
  get 'locations/search'

end
