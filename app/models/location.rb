class Location < ApplicationRecord
    validates :name, presence: true
    validates :political_unit, presence: true
    validates :lat, presence: true, numericality: { greater_than_or_equal_to: -90.0, less_than_or_equal_to: 90.0 }
    validates :long, presence: true, numericality: { greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0 }

    def display_name
        return "#{name} (#{political_unit})"
    end
end
