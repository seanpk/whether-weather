require 'rest-client'

class LocationService
    @@BASE_URL = 'https://geocoding-api.open-meteo.com/v1/search'

    def self.search(query)
        results = []

        # this needs to be factored out so that the response can be mocked and the request handling can be validated
        # it should also be surounded for error handling in case the request fails
        response = ActiveSupport::JSON.decode(RestClient.get(@@BASE_URL, { params: { name: query } }))

        if (response['results'])
            for result in response['results']
                punit_parts = []
                for punit in ['admin1', 'country'] do
                    punit_parts << result[punit] unless (!result[punit] or result[punit].empty?)
                end
                punit_str = punit_parts.join(', ')
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
