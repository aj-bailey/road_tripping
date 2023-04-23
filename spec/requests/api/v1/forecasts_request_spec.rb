require "rails_helper"

RSpec.describe "Forecasts API Requests" do
   describe "Forecast Index" do
      it "returns current, 5-day and hourly forecasts" do
        VCR.use_cassette("Forecast Request") { get api_v1_forecast_index_path(location: "denver,co") }

        forecast_json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful

        expect(forecast_json[:data][:id]).to eq(nil)
        expect(forecast_json[:data][:type]).to eq("forecast")
        expect(forecast_json[:data][:attributes].keys).to contain_exactly(:current_weather, :daily_weather, :hourly_weather)
        
        expect(forecast_json[:data][:attributes][:current_weather].keys).to contain_exactly(:last_updated,
                                                                                             :temperature,
                                                                                             :feels_like,
                                                                                             :humidity,
                                                                                             :uvi,
                                                                                             :visibility,
                                                                                             :condition,
                                                                                             :icon)

        expect(forecast_json[:data][:attributes][:daily_weather].first.keys).to contain_exactly(:date,
                                                                                           :sunrise,
                                                                                           :sunset,
                                                                                           :max_temp,
                                                                                           :min_temp,
                                                                                           :condition,
                                                                                           :icon)

        expect(forecast_json[:data][:attributes][:hourly_weather].first.keys).to contain_exactly(:time, :temperature, :condition, :icon)

        expect(forecast_json[:data][:attributes][:current_weather][:last_updated]).to be_a(String)
        expect(forecast_json[:data][:attributes][:current_weather][:temperature]).to be_a(Float)
        expect(forecast_json[:data][:attributes][:current_weather][:feels_like]).to be_a(Float)
        expect(forecast_json[:data][:attributes][:current_weather][:humidity]).to be_a(Integer)
        expect(forecast_json[:data][:attributes][:current_weather][:uvi]).to be_a(Float)
        expect(forecast_json[:data][:attributes][:current_weather][:visibility]).to be_a(Float)
        expect(forecast_json[:data][:attributes][:current_weather][:condition]).to be_a(String)
        expect(forecast_json[:data][:attributes][:current_weather][:icon]).to be_a(String)

        forecast_json[:data][:attributes][:daily_weather].each do |day_weather|
          expect(day_weather[:date]).to be_a(String)
          expect(day_weather[:sunrise]).to be_a(String)
          expect(day_weather[:sunset]).to be_a(String)
          expect(day_weather[:max_temp]).to be_a(Float)
          expect(day_weather[:min_temp]).to be_a(Float)
          expect(day_weather[:condition]).to be_a(String)
          expect(day_weather[:icon]).to be_a(String)
        end

        forecast_json[:data][:attributes][:hourly_weather].each do |hour_weather|
          expect(hour_weather[:time]).to be_a(String)
          expect(hour_weather[:temperature]).to be_a(Float)
          expect(hour_weather[:condition]).to be_a(String)
          expect(hour_weather[:icon]).to be_a(String)
        end
      end
   end
end