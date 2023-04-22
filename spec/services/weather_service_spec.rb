require "rails_helper"

RSpec.describe WeatherService do
  describe "#instance methods" do
    let(:service) { WeatherService.new({:lat=>39.74001, :lng=>-104.99202}) }
    let(:forecast) { VCR.use_cassette("Weather Denver") { service.get_forecast } }

    describe "#initialize" do
      it "exists" do
        expect(service).to be_a(WeatherService)
      end
    end

    describe "#get_forecast" do
      it "returns forecast details" do
        expect(forecast).to be_a(Hash)
        expect(forecast.keys).to include(:current, :forecast)
        expect(forecast[:current].keys).to include(:last_updated, :temp_f, :condition, :humidity, :feelslike_f, :vis_miles, :uv)
        expect(forecast[:forecast][:forecastday].first.keys).to include(:date, :day, :astro, :hour)
        expect(forecast[:forecast][:forecastday].first[:day].keys).to include(:maxtemp_f, :mintemp_f, :condition)
        expect(forecast[:forecast][:forecastday].first[:astro].keys).to include(:sunrise, :sunset)
        expect(forecast[:forecast][:forecastday].first[:hour].first.keys).to include(:time, :temp_f, :condition)
      end
    end
  end
end