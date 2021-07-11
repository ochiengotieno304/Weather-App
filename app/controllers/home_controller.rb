class HomeController < ApplicationController
  def index
	  	require 'net/http'
	  	require 'json'
      require 'time'

      @data = params[:search_box]

      if @data
        # Accuweather locations api endpoint
        @accu_url = 'http://dataservice.accuweather.com/locations/v1/cities/search?q='+ @data +'&apikey=oKWgqkWj5XA0dvx22bTA1y6l4inM5la3'
        @accu_uri = URI(@accu_url)                 # convert @accu_url variable to a URI
        @accu_response = Net::HTTP.get(@accu_uri)  # pass the uri to the response
        @accu_output = JSON.parse(@accu_response)  # parse the JSON

        # Extracting accuweather latitude and longitude values
        lat = @accu_output[0]['GeoPosition']['Latitude'].to_s
        lon = @accu_output[0]['GeoPosition']['Longitude'].to_s

        # lat = '-1.27'
        # lon = '36.804'
        # Openweather forecast api endpoint
        # https://api.openweathermap.org/data/2.5/onecall?lat=-1.27&lon=36.804&units=metric&exclude=minutely&appid=1cc879771ffb654e030d0801eb0df537
        @open_url = 'https://api.openweathermap.org/data/2.5/onecall?lat='+ lat +'&lon='+ lon +'&units=metric&exclude=minutely&appid=1cc879771ffb654e030d0801eb0df537'
        @open_uri = URI(@open_url)                # convert @open_url variable to a URI
        @open_response = Net::HTTP.get(@open_uri) # pass the uri to the response
        @open_output = JSON.parse(@open_response) # parse the JSON

        # Extract current weather from openweather
        @open_output['current'].each do |key, value|
            #puts "#{key} #{value}"
            case key
            when 'dt'
                @time = value.to_i
            when 'temp'
                @temperature = value.to_i.to_s + ("\u00b0").encode('utf-8') + 'C'
            when 'humidity'
                @humidity = value.to_s + ("\u0025").encode('utf-8')
            when 'wind_speed'
                @wind_speed =value.to_s + 'm/s'
            when 'weather'
                value[0].each do |attribute, content|
                    case attribute
                      when 'description'
                        @description = content
                      when 'icon'
                        @icon = content
                    end
                end
            end
        end


        # Extract hourly weather from openweathermap
        @hourly_weather = @open_output['hourly'].each {|value|}

        # today's hourly forecast
        # hour 1
        @hourly_weather[0].each do |key, value|
            case key
            when 'temp'
                @temp_1 = value.to_s
            when 'dt'
                @time_hour_1 = Time.at(value).strftime("%l:%M %p")
            end
        end

        # hour 2
        @hourly_weather[1].each do |key, value|
            case key
            when 'temp'
                @temp_2 = value.to_s
            when 'dt'
                @time_hour_2 = Time.at(value).strftime("%l:%M %p")
            end
        end

        # hour 3
        @hourly_weather[2].each do |key, value|
            case key
            when 'temp'
                @temp_3 = value.to_s
            when 'dt'
                @time_hour_3 = Time.at(value).strftime("%l:%M %p")
            end
        end

        # hour 4
        @hourly_weather[3].each do |key, value|
            case key
            when 'temp'
                @temp_4 = value.to_s
            when 'dt'
                @time_hour_4 = Time.at(value).strftime("%l:%M %p")
            end
        end

        # hour 5
        @hourly_weather[4].each do |key, value|
            case key
            when 'temp'
                @temp_5 = value.to_s
            when 'dt'
                @time_hour_5 = Time.at(value).strftime("%l:%M %p")
            end
        end

        # hour 6
        @hourly_weather[5].each do |key, value|
            case key
            when 'temp'
                @temp_6 = value.to_s
            when 'dt'
                @time_hour_6 = Time.at(value).strftime("%l:%M %p,")
            end
        end

        # passed to Chart.js
        @hourly_temp = [@temp_1, @temp_2, @temp_3,
              @temp_4, @temp_5, @temp_6].to_json
        @hourly_time = [@time_hour_1, @time_hour_2,@time_hour_3,
              @time_hour_4, @time_hour_5, @time_hour_6].to_json


        # Extract daily weather from openweather
        @daily_weather = @open_output['daily'].each {|value|}

        # today forecast
        @daily_weather[0].each do |key, value|
            case key
            when 'dt'
                @time_1 = value.to_i
            when 'humidity'
                @humidity_1 = value.to_s + '%'
            when 'weather'
                value[0].each do |attribute, content|
                    case attribute
                        when 'description'
                            @description_1 = content
                        when 'icon'
                            @icon_1 = content
                    end
                end
            end
        end

        # tomorrow day forecast
        @daily_weather[1].each do |key, value|
            case key
            when 'dt'
                @time_2 = value.to_i
            when 'humidity'
                @humidity_2 = value.to_s + '%'
            when 'weather'
                value[0].each do |attribute, content|
                    case attribute
                        when 'description'
                            @description_2 = content
                        when 'icon'
                            @icon_2 = content
                    end
                end
            end
        end

        # second day forecast
        @daily_weather[2].each do |key, value|
            case key
            when 'dt'
                @time_3 = value.to_i
            when 'humidity'
                @humidity_3 = value.to_s + '%'
            when 'weather'
                value[0].each do |attribute, content|
                    case attribute
                        when 'description'
                            @description_3= content
                        when 'icon'
                            @icon_3 = content
                    end
                end
            end
        end

        @today = Time.at(@time).strftime("%l:%M %p, %a, %b %d, %Y")
        @tomorrow_1 = Time.at(@time_1).strftime("%b %d")
        @tomorrow_2 = Time.at(@time_2).strftime("%b %d")
        @tomorrow_3 = Time.at(@time_3).strftime("%b %d")
      end

	end
end
