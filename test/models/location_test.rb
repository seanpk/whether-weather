require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "should not save location without name and coordinates" do
    location = Location.new
    assert_not(location.save)
  end

  test "invalid without required fields" do
    location = Location.new do |loc|
      loc.political_unit = "No Matter"
      loc.lat = 0
      loc.long = 0
    end
    assert_not(location.valid?)
    location.name = "Here"
    assert(location.valid?)
    location.political_unit = nil
    assert_not(location.valid?)

    location = Location.new(name: "Somewhere", political_unit: "Elsewhere")
    assert_not(location.valid?)
  end

  test "latiutude should be in [-90, 90]" do
    location = locations(:nonsense)
    assert(location.valid?)
    location.lat = 91
    assert_not(location.valid?)
    location.lat = -1
    assert(location.valid?)
    location.lat = -100
    assert_not(location.valid?)
  end

  test "longitude should be in [-180, 180]" do
    location = locations(:nonsense)
    assert(location.valid?)
    location.long = 181
    assert_not(location.valid?)
    location.long = -1
    assert(location.valid?)
    location.long = -200
    assert_not(location.valid?)
  end

  test "coordinates can be decimals" do
    location = Location.new(name: "Hello", political_unit: "World", lat: 35.032, long: -12.12)
    assert(location.valid?)
  end

  test "display name is available" do
    toronto = locations(:toronto)
    assert_equal('Toronto (Ontario, Canada)', toronto.display_name)
  end
end
