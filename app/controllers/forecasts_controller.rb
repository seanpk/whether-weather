require 'forecast_service'

class ForecastsController < ApplicationController
  def show
    @location = Location.find_by(uuid: params[:uuid])
    @forecast = ForecastService.predict(@location)
  end
end
