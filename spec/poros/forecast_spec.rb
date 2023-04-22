require "rails_helper"

RSpec.describe Forecast do
  describe "#instance methods" do
    let(:service) { WeatherService.new({:lat=>39.74001, :lng=>-104.99202}) }
    let(:weather) { VCR.use_cassette("Weather Denver") { service.get_forecast } }
    let(:forecast) { Forecast.new(weather) }

    describe "#initialize" do
      it "exists" do
        expect(forecast).to be_a(Forecast)
      end

      it "has readable attributes" do
        expect(forecast.current_weather).to be_a(Hash)
        expect(forecast.daily_weather).to be_an(Array)
        expect(forecast.hourly_weather).to be_an(Array)
      end
    end
  end
end