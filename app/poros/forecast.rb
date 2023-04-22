class Forecast
  attr_reader :id, :current_weather, :daily_weather, :hourly_weather

  def initialize(data)
    @current_weather = parse_current_weather(data[:current])
    @daily_weather = parse_daily_weather(data[:forecast][:forecastday][1..5])
    @hourly_weather = parse_hourly_weather(data[:forecast][:forecastday][0][:hour])
  end

  private

    def parse_current_weather(data)
      {
        last_updated: data[:last_updated],
        temperature: data[:temp_f],
        feels_like: data[:feelslike_f],
        humidity: data[:humidity],
        uvi: data[:uv],
        visibility: data[:vis_miles],
        condition: data[:condition][:text],
        icon: data[:condition][:icon]
      }
    end

    def parse_daily_weather(data)
      data.map do |daily_weather|
        {
          date: daily_weather[:date],
          sunrise: daily_weather[:astro][:sunrise],
          sunset: daily_weather[:astro][:sunset],
          max_temp: daily_weather[:day][:maxtemp_f],
          min_temp: daily_weather[:day][:mintemp_f],
          condition: daily_weather[:day][:condition][:text],
          icon: daily_weather[:day][:condition][:icon]
        }
      end
    end

    def parse_hourly_weather(data)
      data.map do |hourly_weather|
        {
          time: hourly_weather[:time].to_datetime.strftime("%H:%M"),
          temperature: hourly_weather[:temp_f],
          condition: hourly_weather[:condition][:text],
          icon: hourly_weather[:condition][:icon]
        }
      end
    end
end
