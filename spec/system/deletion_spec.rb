require 'rails_helper'

RSpec.describe "delete locations and have all be well", type: :system do
  fixtures :locations, :forecasts
  
  before do
    driven_by(:rack_test)
  end

  def deletion_checker(deleter, confirmation_text)
    initial_location_count = Location.count

    expect(deleter['class']).to eq('deleter')
    expect(deleter['data-turbo-confirm']).to eq(confirmation_text)

    # NOTE: using :rack_test the javascript modals confirmation modals are not displayed the action just happens
    deleter.click
    expect(initial_location_count - 1).to eq(Location.count)
    expect(page.current_path).to eq('/')
  end

  it "can delete from the home page" do
    confirmation_text = "Remove #{locations(:swan_river).display_name}?"

    visit "/"

    deleter = find_button("Remove Location", match: :first)
    deletion_checker(deleter, confirmation_text)
  end

  it "can delete from the location page" do
    location = locations(:raleigh)
    confirmation_text = "Remove #{location.display_name}?"

    visit (location_path(location))

    deleter = find_button("Remove Location")
    deletion_checker(deleter, confirmation_text)
  end
end