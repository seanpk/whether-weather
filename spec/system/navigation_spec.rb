require 'rails_helper'

RSpec.describe "navigating the site without creating or desroying", type: :system do
  fixtures :locations
  
  before do
    driven_by(:rack_test)
  end

  let(:loc_exists) { Location.new(
    name: "Swan River",
    political_unit: "Manitoba, Canada",
    lat: 52.1058,
    long: -101.26759,
    uuid: "b320f656-e0ab-5c1b-ad70-a10aba517847"
  )}

  it "has links to everything that exists on the home page" do
    visit "/"

    expect(page).to have_text("Whether Weather")
    expect(page).to have_field("query")

    row_count = 0
    all('tr').each do |tr|
        row_count += 1
        expect(tr).to have_link(href: /\/locations\//)
        expect(tr).to have_button("Get Forecast")
        expect(tr).to have_button("Remove Location")
    end

    expect(row_count).to eq(Location.count)
  end

  it "has links to relevant places and actions on the location details page" do
    visit location_path(loc_exists)

    expect(page).to have_link("Front Page", href: root_path)
    expect(page).to have_link("Get Forecast", href: location_forecast_path(loc_exists))
    expect(page).to have_button("Remove Location")
  end

  it "has links to relevant places and actions on the location forecast page" do
    visit location_forecast_path(loc_exists)

    expect(page).to have_link("Front Page", href: root_path)
    expect(page).to have_link("Location Page", href: location_path(loc_exists))
  end

  it "has links to relevant places and actions on the search results page" do
    visit "/locations/search?query=#{loc_exists.name}"

    expect(page).to have_link("Front Page", href: root_path)

    found_first = false
    all('tr').each do |tr|
        unless found_first
            # the first row should be a location we already have in our list
            expect(tr).to have_link(href: /\/locations\//)
            expect(tr).to have_button("Get Forecast")
            expect(tr).to have_button("Remove Location")
            found_first = true
        else
            expect(tr).to have_text(loc_exists.name)
            expect(tr).to have_button("Add to My List")
        end
    end

    expect(page).to have_button("Search Again")
  end
  

end