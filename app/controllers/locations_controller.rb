require 'location_service'

class LocationsController < ApplicationController
  def index
  end
  def search
    @locations = LocationService.search(params[:query])
  end
end
