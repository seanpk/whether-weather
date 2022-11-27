require 'forecast_service'

class ForecastsController < ApplicationController
  FORECAST_TTL = 60 * 60 * 6 # 6 hours

  def show
    @location = Location.find_by_uuid(params[:uuid])

    @forecast = Forecast.find_by_location_id(@location.id) || Forecast.new(location: @location)
    unless (@forecast.updated_at and @forecast.updated_at > DateTime.now.ago(FORECAST_TTL))
      refresh_forecast
    end
  end

  def refresh_forecast
    newfc = ForecastService.predict(@location)
    @forecast.latest = newfc.latest
    @forecast.save!
  end
end
