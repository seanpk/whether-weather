class Forecast < ApplicationRecord
  belongs_to :location
  serialize :latest, Array

  validates_with ForecastValidator

  def self.createForecastDay(date, high, low)
    return {
      date: date,
      high: high,
      low: low
    }
  end
end
