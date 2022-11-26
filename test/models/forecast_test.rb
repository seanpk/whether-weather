require "test_helper"

class ForecastTest < ActiveSupport::TestCase
  test "the daily forecast maker works" do
    date = "2022-11-25"
    high = 6.5
    low = -2.25
    df = Forecast.createForecastDay(date, high, low)
    assert_equal({
        date: date,
        high: high,
        low: low
      }, df)
  end

  test "valid fixtures are valid" do
    for idx in [:raleigh_one, :toronto_one] do
      fc = forecasts(idx)
      assert(fc.valid?)
    end
  end

  test "invalid without location" do
    fc_for_nowhere = Forecast.new(latest: [{
      date: "2022-11-25",
      high: 21.5,
      low: 14
    }])
    assert_not(fc_for_nowhere.valid?)
    assert_not_empty(fc_for_nowhere.errors[:location])
  end

  test "invalid with a non-compliant day forecast" do
    fc = Forecast.new(location: locations(:nonsense))
    assert_not(fc.valid?)
    assert_not_empty(fc.errors[:latest])
    fc.latest = []
    assert_not_empty(fc.errors[:latest])
    fc.latest.append({foo: "bar"})
    assert_not_empty(fc.errors[:latest])
    fc.latest = [Forecast.createForecastDay("2022-11-25", 12, 3)]
    assert(fc.valid?)
  end
end
