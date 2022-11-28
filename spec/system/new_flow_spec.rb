require 'rails_helper'

RSpec.describe "straightforward flow to add a location and get a forecast for it", type: :system do
  fixtures :locations, :forecasts
  
  before do
    driven_by(:rack_test)
  end

  let(:loc_new) { Location.new(
    name: "London",
    political_unit: "Ontario, Canada",
    lat: 42.98339,
    long: -81.23304,
    uuid: "e9da05c9-136b-594f-ba53-33eb3f2b334a"
  )}
  let(:loc_exists) { Location.new(
    name: "Swan River",
    political_unit: "Manitoba, Canada",
    lat: 52.1058,
    long: -101.26759,
    uuid: "b320f656-e0ab-5c1b-ad70-a10aba517847"
  )}

  it "can search a location from the home page" do
    visit "/"

    fill_in "query", :with => loc_new.name
    click_button "Search"

    expect(page).to have_text("Matching Locations for \"#{loc_new.name}\"")
  end

  it "can add a location to my results" do
    visit "/locations/search?query=#{loc_new.name}"

    within('tr', text: loc_new.display_name) do
      click_button "Add to My List"
    end

    expect(page).to have_text("Latitude")
    expect(page).to have_text(loc_new.lat)
    expect(page).to have_text("Longitude")
    expect(page).to have_text(loc_new.long)

    expect(page).to have_link("Get Forecast")
  end

  it "can get a an exiting forecast" do
    visit location_forecast_path(loc_exists)

    expect(page).to have_text("Forecast for #{loc_exists.display_name}")
    expect(page).to have_text("°C")
    expect(page).to have_text("Last updated: #{forecasts(:srmb).updated_at}")
    expect(page).to have_text("Next auto update after")
  end

  it "can get a an new forecast" do
    location = locations(:raleigh)
    visit location_forecast_path(location)

    expect(page).to have_text("Forecast for #{location.display_name}")
    expect(page).to have_text("Last updated: #{Forecast.find_by_location_id(location.id).updated_at}")
  end
end
