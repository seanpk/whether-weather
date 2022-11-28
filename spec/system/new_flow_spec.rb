require 'rails_helper'

RSpec.describe "NewFlow", type: :system do
  fixtures :locations
  
  before do
    driven_by(:rack_test)
  end

  let(:loc_new) { Location.new(
    name: "London",
    political_unit: "Ontario, Canada",
    lat: 42.98339,
    long: -81.23304
  )}
  let(:loc_exists) { Location.new(
    name: "Swan River",
    political_unit: "Manitoba, Canada",
    lat: 52.1058,
    long: -101.26759,
    uuid: "b320f656-e0ab-5c1b-ad70-a10aba517847"
  )}

  it "can search for a location from the home page" do
    visit "/"

    fill_in "query", :with => loc_new.name
    click_button "Search"

    expect(page).to have_text("Matching Locations for \"#{loc_new.name}\"")
  end

  it "shows a list of matching search results" do
    visit "/locations/search?query=#{loc_new.name}"

    all('tr').each do |tr|
      expect(tr).to have_text(loc_new.name)
      expect(tr).to have_button("Add to My List")
    end
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

  it "can get a new forecast" do
    visit "/locations/#{loc_exists.get_uuid}"

    click_link "Get Forecast"

    expect(page).to have_text("Forecast for #{loc_exists.display_name}")
    expect(page).to have_text("°C")
    expect(page).to have_text("Next auto update after")
  end
end
