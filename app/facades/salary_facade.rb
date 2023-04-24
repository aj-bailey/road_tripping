class SalaryFacade
  def initialize(params)
    @params = params
  end

  def salary_details
    weather = current_weather
    salary = TeleportService.new(@params).salary_information
    
    Salary.new(combine_json_data(weather, salary))
  end

  private

    def current_weather
      map_quest_location = MapQuestService.new(location: @params[:destination]).get_location
      coordinates = map_quest_location[:results].first[:locations].first[:latLng]

      forecast = WeatherService.new(coordinates).get_forecast
    end

    def combine_json_data(weather, salary)
      weather_salary_json = weather.merge(salary)
      weather_salary_json.merge(destination: @params[:destination])
    end
end