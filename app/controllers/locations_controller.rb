require 'location_service'

class LocationsController < ApplicationController
  def index
  end
  
  def search
    @locations = LocationService.search(params[:query])
  end

  def create
    loc_hash = params[:location]
    @location = Location.new(
      name: loc_hash['name'],
      political_unit: loc_hash['political_unit'],
      lat: loc_hash['lat'],
      long: loc_hash['long'],
      uuid: loc_hash['uuid']
    )
    existing_location = Location.find_by_uuid(@location.uuid)

    if (existing_location)
      @location = existing_location
      redirect_to location_path(@location), status: :found
    elsif (@location.save)
      # redirect_to location_path(@location), status: :created
      # browswers are not doing that redirect, they're taking the 201 and staying on /locations
      redirect_to location_path(@location)
    else
      render :file => 'public/500.html', :status => :internal_server_error, :layout => false
    end
  end

  def destroy
    @location = Location.find_by(uuid: params[:uuid])
    if @location
      @location.destroy
    end
    redirect_to :root
  end

  def show
    @location = Location.find_by_uuid(params[:uuid])
    if (!@location)
      render :file => 'public/404.html', :status => :not_found, :layout => false
      return
    end
  end
end
