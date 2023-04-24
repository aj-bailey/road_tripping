class SalariesFacade
  def initialize(params)
    @params = params
  end

  def salaries_details
    weather = current_weather
    salaries = TeleportService.new(@params).salaries_information
    
    Salaries.new(combine_json_data(weather, salaries))
  end

  private

    def current_weather
      map_quest_location = MapQuestService.new(location: @params[:destination]).get_location
      coordinates = map_quest_location[:results].first[:locations].first[:latLng]

      forecast = WeatherService.new(coordinates).get_forecast
    end

    def combine_json_data(weather, salaries)
      weather_salaries_json = weather.merge(salaries)
      weather_salaries_json.merge(destination: @params[:destination])
    end
end