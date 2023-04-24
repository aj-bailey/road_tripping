require "rails_helper"

RSpec.describe MapQuestService do
  describe "#instance methods" do
    let(:service_denver) { MapQuestService.new(location: "denver,co") }
    let(:service_chicago) { MapQuestService.new(origin: "cincinatti,oh", destination: "chicago,il") }
    let(:location) { VCR.use_cassette("MapQuest Service Denver") { service_denver.get_location } }
    let(:directions) { VCR.use_cassette("Chicago Directions") { service_chicago.get_directions } }

    describe "initialize" do
      it "exists" do
        expect(service_denver).to be_a(MapQuestService)
      end
    end

    describe "get_location" do
      it "returns details for map quest location" do
        expect(location).to be_a(Hash)
        expect(location[:results][0][:locations][0][:latLng]).to be_a(Hash)
        expect(location[:results][0][:locations][0][:latLng].keys).to contain_exactly(:lat, :lng)
      end
    end

    describe "get_directions" do
      it "returns directions from map quest" do
        expect(directions).to be_a(Hash)
        expect(directions.keys).to include(:route)

        expect(directions[:route].keys).to include(:locations, :formattedTime, :time)
      end
    end
  end
end