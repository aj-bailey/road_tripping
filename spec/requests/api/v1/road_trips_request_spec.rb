require "rails_helper"

RSpec.describe "Road Trips API Requests" do
  describe "Road Trips Create" do
    before(:each) do
      @user = User.create!(email: "whatever@example.com", password: "password", password_confirmation: "password")
    end
    
    context "Successful Request" do
      it "returns road trip json object when api_key successfully authenticated" do
        params = {
          "origin": "Cincinatti,OH",
          "destination": "Chicago,IL",
          "api_key": @user.api_key
        }

        VCR.use_cassette("Cincinatti to Chicago Trip") { post api_v1_road_trip_index_path, params: params }

        road_trip_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful

        expect(road_trip_response[:data].keys).to contain_exactly(:id, :type, :attributes)
        expect(road_trip_response[:data][:id]).to eq(nil)
        expect(road_trip_response[:data][:type]).to eq("road_trip")

        expect(road_trip_response[:data][:attributes].keys).to contain_exactly(:start_city,
                                                                               :end_city,
                                                                               :travel_time,
                                                                               :weather_at_eta)
        expect(road_trip_response[:data][:attributes][:start_city]).to eq("Cincinnati, OH")
        expect(road_trip_response[:data][:attributes][:end_city]).to eq("Chicago, IL")
        expect(road_trip_response[:data][:attributes][:travel_time]).to eq("04:42:42")

        expect(road_trip_response[:data][:attributes][:weather_at_eta].keys).to contain_exactly(:dateTime, :temperature, :condition)
        expect(road_trip_response[:data][:attributes][:weather_at_eta][:dateTime]).to eq("2023-04-23 18:38")
        expect(road_trip_response[:data][:attributes][:weather_at_eta][:temperature]).to eq(44.1)
        expect(road_trip_response[:data][:attributes][:weather_at_eta][:condition]).to eq("Partly cloudy")
      end

      it "returns road trip json object with start and end city, impossible route and null weather attributes when no route available" do
        params = {
          "origin": "New York,NY",
          "destination": "London,UK",
          "api_key": @user.api_key
        }

        VCR.use_cassette("New York to London Trip") { post api_v1_road_trip_index_path, params: params }

        road_trip_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful

        expect(road_trip_response[:data].keys).to contain_exactly(:id, :type, :attributes)
        expect(road_trip_response[:data][:id]).to eq(nil)
        expect(road_trip_response[:data][:type]).to eq("road_trip")

        expect(road_trip_response[:data][:attributes].keys).to contain_exactly(:start_city,
                                                                               :end_city,
                                                                               :travel_time,
                                                                               :weather_at_eta)
        expect(road_trip_response[:data][:attributes][:start_city]).to eq("New York,NY")
        expect(road_trip_response[:data][:attributes][:end_city]).to eq("London,UK")
        expect(road_trip_response[:data][:attributes][:travel_time]).to eq("Impossible Route")
        expect(road_trip_response[:data][:attributes][:weather_at_eta]).to eq(nil)
      end
    end

    context "Unsuccessful Request" do
      it "returns 401 error when api key is invalid" do
        params = {
          "origin": "Cincinatti,OH",
          "destination": "Chicago,IL",
          "api_key": "invalid_api_key"
        }

        post api_v1_road_trip_index_path, params: params

        road_trip_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(401)

        expect(road_trip_response[:message]).to eq("Invalid Credentials")
        expect(road_trip_response[:errors]).to eq("Unauthorized API key")
      end

      it "returns 401 error when api key is missing" do
        post api_v1_road_trip_index_path

        road_trip_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(401)

        expect(road_trip_response[:message]).to eq("Invalid Credentials")
        expect(road_trip_response[:errors]).to eq("Unauthorized API key")
      end
    end
  end
end