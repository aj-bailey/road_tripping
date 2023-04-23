class WeatherFacade
  def initialize(params)
    @params = params
  end

  def forecast
    map_quest_location = MapQuestService.new(@params).get_location
    coordinates = coordinates(map_quest_location)
    
    forecast = WeatherService.new(coordinates).get_forecast

    Forecast.new(forecast)
  end

  private

    def coordinates(location)
      location[:results].first[:locations].first[:latLng]
    end
end
