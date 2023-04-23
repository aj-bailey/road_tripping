class RoadTrip
  attr_reader :id, :start_city, :end_city, :travel_time, :weather_at_eta

  def initialize(data)
    @data = data
    @start_city = city_state(data[:route][:locations].first)
    @end_city = city_state(data[:route][:locations].last)
    @travel_time = data[:route][:formattedTime]
    @weather_at_eta = destination_weather
  end

  private

    def city_state(location)
      "#{location[:adminArea5]}, #{location[:adminArea3]}"
    end

    def destination_weather
      {
        "dateTime": local_eta,
        "temperature": eta_hour_weather[:temp_f],
        "condition": eta_hour_weather[:condition][:text]
      }
    end

    def local_eta
      trip_duration_seconds = @data[:route][:time]
      destination_local_start_time = @data[:location][:localtime].to_time
      destination_local_end_time = destination_local_start_time + trip_duration_seconds

      destination_local_end_time.to_datetime.strftime("%Y-%m-%d %H:%M")
    end

    def eta_hour_weather
      nearest_hour_date_time = nearest_hour(local_eta)
      date_forecast = date_forecast(nearest_hour_date_time)

      date_forecast[:hour].find { |hour_forecast| hour_forecast[:time] == nearest_hour_date_time }
    end

    def nearest_hour(date_time)
      minutes = date_time.to_datetime.strftime("%M").to_i

      if minutes >= 30
        nearest_hour_date_time = date_time.to_time.end_of_hour + 1
      else
        nearest_hour_date_time = date_time.to_time.beginning_of_hour
      end

      nearest_hour_date_time.to_datetime.strftime("%Y-%m-%d %H:%M")
    end

    def date_forecast(date_time)
      @data[:forecast][:forecastday].find do
        |forecast_day| forecast_day[:date] == date_time.split(" ")[0]
      end
    end
end
