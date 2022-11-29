# README: Whether Weather

A simple weather app to practice using the technology stack used by RoleModel Software,
which a good example of a preferred stack of many Ruby on Rails companies.
I have never built anything with Rails before, so here we go!

## Running the App

... on your local machine. By the end of this section you'll have the app running in development mode and available in your browser at: <http://127.0.0.1:3000>.

### OS-Level Prerequisites

Here are the key items to have installed to get going (to match exactly what I developed with):
 
- Ruby version 3.1.2
- Bundler version 2.3.7
- Rails version 7.0.4
- SQLite version 3.37.2

### App-Level Setup

After cloning the repo (e.g. `git clone https://github.com/seanpk/whether-weather.git`), from the `whether-weather` directory run these commands:

1. Install the dependencies:  
    `bundler`
2. Run the database migrations (to setup your sqlite database):  
    `bundler exec rails db:migrate`
3. Run tests (they should all pass):
    1. Unit tests (mostly for models - implemented using Rails defaults):  
        `bundler exec rails test`
    2. System tests (implmented using RSpec):  
        `bundler exec rspec`
4. Launch the server:  
    `bundler exec rails server`

Now you can visit the app in your browswer at: <http://127.0.0.1:3000>.

## Notes and Limitations

While this project definitely took longer to build than I had hoped, it still has a number of items that I'd like to have be different.

### User Wishlist

The app should be quite intuitive to navigate and use, but it is good to note some deficiencies of the current implementation (numbered for reference):

1. Update the page title on each page to make history a lot easier to navigate!
2. Let me provide a search string that includes more than a city name, and/or let me get more than 10 search results (these may be / are limitations of the free search API used)
3. It would be nice to be able to force a forecast refresh from the forecast page
4. Forecasts would be a lot more usable if they had additional information beyond the highs and lows for the next 7 days
5. The location page would be a lot more interesting if it integrated a map instead of just listing the coordinates
6. Or maybe the location page shouldn't exist on its own and the forecast should be shown directly on it!
7. Multiuser support would be great too

### Technical TODOs

There are always TODOs for any piece of software. As people use the software, some of them turn out to be unnecessary, or of insufficient value to work on. Still, here are the ones I'd do if I kept working on this project:

1. Refactor the API services: 
    1. [`LocationService`](./lib/location_service.rb) and [`ForecastService`](./lib/forecast_service.rb) should be moved into a folder, maybe even the same file, and setup the library(ies) to support auto-reload (following [something like this](https://stackoverflow.com/a/10097015))
    2. Implement a better pattern to isolate the 3rd party services, simplify testing, facilitate integration of other data providers (including our own database - there's some data integration happening in the [`LocationsController`](./app/controllers/locations_controller.rb) that could/should be done in the service)
    3. Add unit tests to this area of the code
    4. Add an IP location API and have it be another lookup option
2. Add the ability to lookup a forecast without having to have the location in the database; maybe on at `POST /forecasts` where the payload provides the `Location` values, just as is done to create a location in the first place at `POST /locations`
    1. The location could then be added from this forecast page
3. Expand the [`Forecast` model](./app/models/forecast.rb) to include more data; especially the following daily values from [Open-Meteo](https://open-meteo.com/en/docs):
    1. Dispaly the daily weather with `weathercode` (will require creating a data representation of the meaning of those codes for display)
    2. Show the expected precipitation with `precipitation_sum`
    3. Provide info about the wind with `windspeed_10m_max` and `windgusts_10m_max`
    4. Display the solar information with `sunrise` and `sunset`
4. Implement a `User` model and make the system "multiuser" (even without worrying about passwords, a simple system that let users provide a name and switch over to the associated data would work)
5. Use [Hotwired (Turbo/Stimulus)](https://hotwired.dev/) to make the app more dynamic
6. Publish the app to a hosting service so that it is easier for others to play with
7. Apply some responsive CSS framework to make the UI better, especially to:
    1. Use the richer forecast model to make the info on that page more consumable
    2. To deduplicate a bunch of code in the views that is duplicated (although I have to wonder - Rails probably has a way of doing this already, e.g. making reusable widgets, that I just didn't learn during this crash course implementation sesion)

## Design Experience and Choices

Being completely new to Rails, perhaps especially because my most recent apps all started with design at the API level using [BlueOak Server's Swagger support](https://github.com/BlueOakJS/blueoak-server#swagger-openapi), designing from the database out was quite awkward for me. I spent a lot of time trying to understand how the Rails platform should be used and reorient my thinking to work with it. I also spent a lot of time trying to debug issues caused by having an incorrect or incomplete mental model of the platform.

(I think there is only one issue that I resolved without also learning why it occurred, what caused it, and having my mental model improved. It had to do with only being able to insert a single Forecast into the forecasts table because of a foreign key constraint.)

In addition to finding it awkward to design the data model starting at the database instead of at the API, I found that my experience design did not settle out until much later than I was used to. I know part of this was learning what Rails could do by default, and working without the expectation of there being an SPA to serve the user. Working with a relational database, rather than a document store, also made it feel like there was a lot more commitment in the data design than I was used to. (Of course, with Rails' database migrations, I should not be as concerned about that, but that was new to me too and I didn't quite trust it - or myself with it!)

Still, in the end I am happy with the straightforward user experience, the test coverage that exists (both unit and system), the isolation of the 3rd-party APIs, the simple data model, and the few non-standard / anti-default things I did (hopefully without becoming too cleaver!).

### Viewing the Design from the Outside In

The app really only consists of 4 pages:

1. The List of Locations, which also serves as the home page (with a bit of extra text at the top). In addition to listing out the saved locations, it is where the user can access the search to find new locations. The locations are ordered firstly by how recent their forecast is, and secondly by how recently they were saved. For each saved location there are 3 actions available to the user:
    1. A link to view the Location Details
    2. A button to view the Location Forecast
    3. A button to remove the location from the list
2. The Search Results, which show the results of searching for a place name. When the results include a location that is already saved, it is displayed at the top of the list and shown in the same way as it does on the List of Locations page. For new / unsaved locations, they are displayed as two components:
    1. The "display name", which includes the state/province/administrative region and the country name, as text
    2. A button to add the location to your list of locations
3. The Location Details, which really just show the "display name" and the coordinates of the location, as well as a button to remove it from the list of saved locations
4. The Location Forecast, which shows the high and low temperature in Celsius for the next 7 days. This is a very barebones page, both in the data displayed and in its display. One note is that the page will only attempt to fetch new data through the LocationService if the current forecast is older than 6 hours.

Links (and buttons) exist to facilite in-app navigation between the pages. Actions to create or delete locations are implemented in buttons and land you on a page that makes sense. With JavaScript enabled, the delete action is confirmed with an alert.

### Peeking Inside to See More

There are a few things I want to record about a few different areas of the implementation.

#### Isolating 3rd-party APIs

All calls to the 3rd-party APIs are made through static functions provided by two service classes that exist in the `lib` directory. Each of those functions handles making the REST call and filtering and transforming the result into the data model represented by the associated active models. As mentioned above, these libraries can be better integrated into the Rails framework and better implemented for testability.

#### Treating the Forecasts Table as an Expensive Memory Cache

Regarding the translation, especially for the ForecastService, I chose to store the 7-day forecast in a single database field, `Forecast.latest`. Perhaps this was just me leaning a bit too much on my experience from working with document stores, and if there is a better pattern I'd like to learn it. Still, this makes it pretty easy to add additional data if more were gotten from the API.

Ultimately, if there is a way to implement the Forecast model as something that only exists in a memory cache, I think that would be the best choice for it. Especially since putting it in the database meant that I created a custom validator, [`ForecastValidator`](./app/models/concerns/forecast_validator.rb), to handle the contents of the `latest` field especially. So this code would also have to be updated if the Forecast model were expanded to include more data from a weather API.

#### Re-inventing Composite Primary Keys (Outside the Database)

As for the Location model, it too has some "non-default" behavior. I decided that the best way to make sure that duplicate entries were not made for the same location, was to generate a UUID. The UUID is generated from the string that includes the "display name" and the coordinates of the location. This also required that I use the UUID as the path parameter for locating the resource through the web. 

Maybe a composite primary key would've done the trick and saved a bunch of work. Probably this is a sign of my rust working with relational databases. On the other hand, all that "work" was really learning and I wouldn't know about `before_validation`, the use of `to_param`, or as much about Rails migrations without this! :-)

Still, a composite primary key would've changed the default in Rails as well (at least as far as I know). I would be happy to learn whatever solution is the more regular and recognized pattern.

#### Testing without RSpec

Since at the outset I knew that I'd have to learn a ton to implement this project, I decided to simplify my beginnings by writing unit tests for the models using the Rails built-in technology. When I went to add RSpec later, for the purpose of writing system tests, I saw how it would've been helpful from the start. 

Ultimately, because I was adding RSpec relatively late to the process, I created my second specs by hand rather than using a generator. For that same reason, the model unit tests are still done using the Rails default.


## The Original Challenge

> From Caleb Woods on November 18, 2022

**Build a small Multi-Location Weather Forecasting Application**

Using TDD and Ruby on Rails build a simple application that allows a user to:

1. Create multiple locations by (IP Address and/or text address)
2. ActiveRecord backed models
3. View the 7-day forecast for each location; highlighting High and Low temps for each day

Bonuses:

1. Chart the highs/lows
2. Leverage Stimulus/Turbo for some of the CRUD interactions
3. Deploy the application to a PaaS such as Heroku, Render.com, or Fly

Expectations:

1. Complete with ~3-5 hours of effort
2. Share source code through Github with a README that documents how use your program
3. Demonstrate ability to use unit and system tests with a strategy for handling data coming from 3rd party APIs
4. Use RSpec for tests; system tests in RSpec

Given References:

1. Stimulus/Turbo:
    1. [Handbook](https://turbo.hotwired.dev/handbook/introduction)
    2. [3rd Party Tutorial](https://www.hotrails.dev/turbo-rails)
2. [System Tests in RSpec](https://relishapp.com/rspec/rspec-rails/docs/system-specs/system-spec)
3. Weather API: [Open-Meteo](https://open-meteo.com/en/docs)

Other APIs Needed/Used:

1. [Open-Meteo Geolocation](https://open-meteo.com/en/docs/geocoding-api#api-documentation)
2. Geolocation by IP Address ... options - did not implement IP lookup:
    1. [ipinfo.io free plan](https://ipinfo.io/products/ip-geolocation-api)
    2. [ipgeolocation free plan](https://ipgeolocation.io/ip-location-api.html)
    3. [ip-api non-commercial, no API key](https://ip-api.com/docs/api:json)
    4. [ipapi.co free and keyless plan](https://ipapi.co/free/)

