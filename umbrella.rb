require "http"
require "json"
require "ascii_charts"

puts "Lets see if you need an umbrella today."

puts "What is your current location?"

location = gets.chomp

puts "Checking the weather at #{location}"

gmaps_key = ENV.fetch("GMAPS_KEY")

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=#{gmaps_key}" #checks the data against google maps

gmaps_data = HTTP.get(gmaps_url) # gets the data

parsed_gmaps_data = JSON.parse(gmaps_data) # creates navigatable hash from data

results_array = parsed_gmaps_data.fetch("results") # grab the results of the new JSON object

result_hash = results_array.at(0) # use .at to navigate to an spot in an array

geometry_hash = result_hash.fetch("geometry")

location_hash = geometry_hash.fetch("location") # use fetch, because this object is inside another object

# location contains two key-value pairs that are NOT an array, so again, we use .fetch

latitude = location_hash.fetch("lat")
longitude = location_hash.fetch("lng")

puts "Your coordinates are #{latitude}, #{longitude}."

# Now that we have the location coordinates, we get the weather from pirate weather API. Set a variable to the key.

# Here we are grabbing the key that we made in github settings:
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

# then we need the URL

pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{latitude},#{longitude}"

puts "Getting the weather from #{pirate_weather_url}"

# get the weather data
raw_weather_data = HTTP.get(pirate_weather_url)

#parse data to object

parsed_weather_data = JSON.parse(raw_weather_data)

# navigate to current conditions

currently_hash = parsed_weather_data.fetch("currently")

current_temp = currently_hash.fetch("temperature")

puts "Right now it is #{current_temp} Degrees F."

# Some locations in the world do not have minutely data

minutely_hash = parsed_weather_data.fetch("minutely", false)

if minutely_hash
  next_hour_summary = minutely_hash.fetch("summary")
  puts "Next hour: #{next_hour_summary}"
end

hourly_hash = parsed_weather_data.fetch("hourly")

hourly_data_array = hourly_hash.fetch("data")

twelve_hour_prediction = hourly_data_array[1..12]

precip_prob_threshold = 0.10

any_precipitation = false

twelve_hour_prediction.each do |hour_hash|
  precip_prob = hour_hash.fetch("precipProbability")

  if precip_prob > precip_prob_threshold
    any_precipitation = true

    precip_time = Time.at(hour_hash.fetch("time"))

    seconds_from_now seconds_from_now / 60 / 60

    puts "In #{hours_from_now.round} hours, there is a #{(precip_prob * 100).round}% chance of precipitation"
    
  end


end

if any_precipitation == true
  puts "You might want to take an umbrella!"
else
  puts "You probably wont need an umbrella."
end




# trying to figure out ascii CHart
# hours = [1..12]

# hours.each do
#  values = precip_prob.push
# end

# put "#{hours}"

# AsciiCharts::Cartesian.new([precip_array]).draw
