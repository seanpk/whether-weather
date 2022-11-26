class ForecastValidator <  ActiveModel::Validator
    def validate(record)
        if (!record.location)
            record.errors.add(:location, :location_required, message: "The forecast must be for a valid location.")
        elsif (!record.location.valid?)
            record.errors.add(:location, :location_invalid, message: "The forecast must be for a valid location.")
        end

        if (!record.latest or !record.latest.instance_of?(Array) or record.latest.empty?)
            record.errors.add(:latest, :latest_required, message: "The latest forecast must be an non-empty array.")
        else
            for day in record.latest
                if (!(day[:date] and day[:high] and day[:low]))
                    record.errors.add(:latest, :latest_invalid, message: "The elements of latest forecast array must include all required fields.")
                end
            end
        end
    end
end