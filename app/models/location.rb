class Location < ApplicationRecord
    validates :name, presence: true
    validates :political_unit, presence: true
    validates :lat, presence: true, numericality: { greater_than_or_equal_to: -90.0, less_than_or_equal_to: 90.0 }
    validates :long, presence: true, numericality: { greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0 }
    validates :uuid, presence: true, uniqueness: true

    before_validation :get_uuid

    def display_name
        return "#{name} (#{political_unit})"
    end

    def to_str
        return display_name + " [#{lat}, #{long}]"
    end

    def get_uuid
        self.uuid = Digest::UUID.uuid_v5(Digest::UUID::OID_NAMESPACE, to_str())
        return self.uuid
    end

    def to_param
        return get_uuid()
    end
end
