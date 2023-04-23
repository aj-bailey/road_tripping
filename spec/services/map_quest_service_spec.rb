require "rails_helper"

RSpec.describe MapQuestService do
  describe "#instance methods" do
    let(:service) { MapQuestService.new(location: "denver,co")}
    let(:location) { VCR.use_cassette("MapQuest Service Denver") { service.get_location } }

    describe "initialize" do
      it "exists" do
        expect(service).to be_a(MapQuestService)
      end
    end

    describe "get_location" do
      it "returns details for map quest location" do
        expect(location).to be_a(Hash)
        expect(location[:results][0][:locations][0][:latLng]).to be_a(Hash)
        expect(location[:results][0][:locations][0][:latLng].keys).to contain_exactly(:lat, :lng)
      end
    end
  end
end