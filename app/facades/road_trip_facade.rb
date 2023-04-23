class RoadTripFacade
  def initialize(params)
    @params = params
  end

  def trip_details
    directions = MapQuestService.new(@params).get_directions
    destination_coordinates = directions[:route][:locations][-1][:latLng]

    weather = WeatherService.new(destination_coordinates).get_forecast
    
    RoadTrip.new(combine_json_data(directions, weather))
  end

  private

    def combine_json_data(directions, weather)
      directions.merge(weather)
    end
end
