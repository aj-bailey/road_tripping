require "rails_helper"

RSpec.describe RoadTrip do
  describe "#initialize" do
    context "valid route" do
      let(:facade) { RoadTripFacade.new("origin": "Cincinnati,OH", "destination": "Chicago,IL") }
      let(:trip_details) { VCR.use_cassette("Road Trip Facade") { facade.trip_details } }

      it "exists" do
        expect(trip_details).to be_a(RoadTrip)
      end

      it "has readable attributes" do
        expect(trip_details.start_city).to eq("Cincinnati, OH")
        expect(trip_details.end_city).to eq("Chicago, IL")
        expect(trip_details.travel_time).to eq("04:40:45")
        expect(trip_details.weather_at_eta).to be_a(Hash)
      end
    end

    context "invalid route" do
      let(:facade) { RoadTripFacade.new("origin": "New York,NY", "destination": "London,UK") }
      let(:trip_details) { VCR.use_cassette("Road Trip Facade - Invalid Route") { facade.trip_details } }

      it "exists" do
        expect(trip_details).to be_a(RoadTrip)
      end

      it "has readable attributes" do
        expect(trip_details.start_city).to eq("New York,NY")
        expect(trip_details.end_city).to eq("London,UK")
        expect(trip_details.travel_time).to eq("Impossible Route")
        expect(trip_details.weather_at_eta).to eq(nil)
      end
    end
  end
end
