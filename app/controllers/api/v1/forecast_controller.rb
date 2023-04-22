class Api::V1::ForecastController < ApplicationController
  def index
    weather_facade = WeatherFacade.new(params)

    render json: ForecastSerializer.new(weather_facade.forecast)
  end
end