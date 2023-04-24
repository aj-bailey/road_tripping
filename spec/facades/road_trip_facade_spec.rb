require "rails_helper"

RSpec.describe RoadTripFacade do
  describe "#instance methods" do
    let(:facade) { RoadTripFacade.new("origin": "Cincinnati,OH", "destination": "Chicago,IL") }
    let(:trip_details) { VCR.use_cassette("Road Trip Facade") { facade.trip_details } }
    
    describe "#initialize" do
      it "exists" do
        expect(facade).to be_a(RoadTripFacade)
      end
    end

    describe "#trip_details" do
      it "returns a road trip object" do
        expect(trip_details).to be_a(RoadTrip)

        expect(trip_details.start_city).to eq("Cincinnati, OH")
        expect(trip_details.end_city).to eq("Chicago, IL")
        expect(trip_details.travel_time).to eq("04:40:45")
        expect(trip_details.weather_at_eta.keys).to contain_exactly(:dateTime, :temperature, :condition)
        expect(trip_details.weather_at_eta[:dateTime]).to eq("2023-04-24 23:03")
        expect(trip_details.weather_at_eta[:temperature]).to eq(43.3)
        expect(trip_details.weather_at_eta[:condition]).to eq("Partly cloudy")
      end
    end
  end
end