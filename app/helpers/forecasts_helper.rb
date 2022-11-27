module ForecastsHelper
    def temperature_units
        return "°C"
    end

    def next_auto_update_after
        return @forecast.updated_at + ForecastsController::FORECAST_TTL
    end
end
