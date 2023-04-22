class WeatherService
  def initialize(coordinates)
    @coordinates = "#{coordinates[:lat]},#{coordinates[:lng]}"
  end

  def get_forecast
    get_url("/v1/forecast.json?key=#{ENV["WEATHER_API_KEY"]}&q=#{@coordinates}&days=6")
  end

  private
  
    def connection
      Faraday.new(url: "http://api.weatherapi.com")
    end

    def get_url(url)
      response = connection.get(url)
      JSON.parse(response.body, symbolize_names: true)
    end
end
