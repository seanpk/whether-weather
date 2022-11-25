require 'rest-client'

class LocationService
    @@base_url = 'https://geocoding-api.open-meteo.com/v1/search'
    def self.search(query)
        results = []
        response = ActiveSupport::JSON.decode(RestClient.get(@@base_url, { params: { name: query } }))
        if response['results']
            for result in response['results']
                punit_str = "#{result['admin1']}, #{result['country']}"
                results.append(Location.new(
                    name: result['name'],
                    political_unit: punit_str,
                    lat: result['latitude'],
                    long: result['longitude']
                ))
            end
        end

        return results
    end
end
