require "rails_helper"

RSpec.describe WeatherFacade do
  describe "#instance methods" do
    let(:facade) { WeatherFacade.new(location: "denver,co") }
    let(:forecast) { VCR.use_cassette("Weather Facade Denver") { facade.forecast } }

    describe "#initialize" do
      it "exists" do
        expect(facade).to be_a(WeatherFacade)
      end
    end

    describe "#forecast" do
      it "returns a forecast object" do
        expect(forecast).to be_a(Forecast)
      end
    end
  end
end