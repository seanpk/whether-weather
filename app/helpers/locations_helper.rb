module LocationsHelper
    def loc_to_hash(loc)
        return {
            name: loc.name,
            political_unit: loc.political_unit,
            lat: loc.lat,
            long: loc.long,
            uuid: loc.get_uuid()
        }
    end
end
