class HomeController < ApplicationController
  def index
	  	require 'net/http'
	  	require 'json'

      @data = params[:search_box]

      # https://api.openweathermap.org/data/2.5/weather?q=Nairobi&units=metric&appid=1cc879771ffb654e030d0801eb0df537
      if @data
        @url = 'https://api.openweathermap.org/data/2.5/weather?q='+ @data +'&units=metric&appid=1cc879771ffb654e030d0801eb0df537'

        @uri = URI(@url)                # convert @url variable to a URI
        @response = Net::HTTP.get(@uri) # pass the uri to the response
        @output = JSON.parse(@response) # parse the JSON

        # get the city name
        @name = @output['name']

        # get the main weather condition
        @output['weather'][0].each do |item, content|
          if item == 'description'
            @content = "#{content}"
          end

          if item == 'icon'
            @icon_id = "#{content}"
          end
        end
        
        # get wind speed
        @output['wind'].each do |item, content|
          if item == 'speed'
            @wind_speed = "Wind speed: #{content}"
          end
        end

        # get weather specs
        @output['main'].each do |item, content|
          if item == 'temp'
            @temperature = "Temperature : #{content}"
          end        

          if item == 'humidity'
            @humidity = "Humidity : #{content}"
          end
        end

      else
        @content = 'Please input city name'
      end

	end
end
