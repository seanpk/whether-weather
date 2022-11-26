require 'rest-client'

class ForecastService
    @@base_url = 'https://api.open-meteo.com/v1/forecast'
    def self.predict(loc)
        fc = Forecast.new(location: loc, latest: [])
        high_key = "temperature_2m_max"
        low_key = "temperature_2m_min"

        # this needs to be factored out so that the response can be mocked and the request handling can be validated
        # it should also be surounded for error handling in case the request fails
        response = ActiveSupport::JSON.decode(RestClient.get(@@base_url, { params: { 
                latitude: loc.lat,
                longitude: loc.long,
                daily: [high_key , low_key],
                timezone: "auto"
                }
            }))
        if (response['daily'])
            dates = response['daily']['time']
            highs = response['daily'][high_key]
            lows = response['daily'][low_key]

            for day in 0..6
                fc.latest.append(Forecast.createForecastDay(dates[day], highs[day], lows[day]))
            end
        end

        return fc
    end
end
