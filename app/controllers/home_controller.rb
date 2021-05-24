class HomeController < ApplicationController
  def index
	  	require 'net/http'
	  	require 'json'

      @data = params[:search_box]

      # https://api.openweathermap.org/data/2.5/weather?q=Nairobi&units=metric&appid=1cc879771ffb654e030d0801eb0df537

		  @url = 'https://api.openweathermap.org/data/2.5/weather?q=Nairobi&units=metric&appid=1cc879771ffb654e030d0801eb0df537'

		  # convert @url variable to a URI
	  	@uri = URI(@url)
	  	# pass the uri to the response
	  	@response = Net::HTTP.get(@uri)
	  	# parse the JSON
	  	@output = JSON.parse(@response)

      # get the sunset time
      @time = @output['sys']['sunset'].to_i
      @sunrise = Time.at(@time)

      # get the city name
      @name = @output['name']

      # get the main weather condition
      @output['weather'][0].each do |item, content|
        if item == 'description'
          @content = "#{item} : #{content}"
        end
      end

     #     "temp": 22.87,
     #     "feels_like": 22.88,
     #     "temp_min": 22,
     #     "temp_max": 24,
     #     "pressure": 1022,
     #     "humidity": 64

      # get weather specs
      @output['main'].each do |item, content|
        if item == 'temp'
          @temperature = "Temperature : #{content}"
        end

        if item == 'feels_like'
          @feel_like = "Feels Like: #{content}"
        end

        if item == 'temp_min'
          @temp_min = "Minimum : #{content}"
        end

        if item == 'temp_max'
          @temp_max = "Maximum : #{content}"
        end

        if item == 'pressure'
          @pressure = "Pressure : #{content}"
        end

        if item == 'humidity'
          @humidity = "Humidity : #{content}"
        end
      end

	end
end

# <!-- {
#   "coord": {
#     "lon": 36.8167,
#     "lat": -1.2833
#   },
#   "weather": [
#     {
#       "id": 500,
#       "main": "Rain",
#       "description": "light rain",
#       "icon": "10d"
#     }
#   ],
#   "base": "stations",
#   "main": {
#     "temp": 22.87,
#     "feels_like": 22.88,
#     "temp_min": 22,
#     "temp_max": 24,
#     "pressure": 1022,
#     "humidity": 64
#   },
#   "visibility": 10000,
#   "wind": {
#     "speed": 2.57,
#     "deg": 90
#   },
#   "rain": {
#     "1h": 0.44
#   },
#   "clouds": {
#     "all": 75
#   },
#   "dt": 1618998448,
#   "sys": {
#     "type": 1,
#     "id": 2558,
#     "country": "KE",
#     "sunrise": 1618975736,
#     "sunset": 1619019213
#   },
#   "timezone": 10800,
#   "id": 184745,
#   "name": "Nairobi",
#   "cod": 200
# } --> %>
