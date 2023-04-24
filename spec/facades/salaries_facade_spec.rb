require "rails_helper"

RSpec.describe SalariesFacade do
  describe "#instance methods" do
    let(:facade) { SalariesFacade.new(destination: "chicago") }
    let(:salaries) { VCR.use_cassette("Chicago Salaries") { facade.salaries_details } }

    describe "#initialize" do
      it "exists" do
        expect(facade).to be_a(SalariesFacade)
      end
    end

    describe "#salaries_details" do
      it "returns a salaries object" do
        expect(salaries).to be_a(Salaries)

        expect(salaries.id).to be(nil)
        expect(salaries.destination).to be_a(String)

        expect(salaries.forecast[:summary]).to be_a(String)
        expect(salaries.forecast[:temperature]).to be_a(String)

        expect(salaries.salaries.first[:title]).to be_a(String)
        expect(salaries.salaries.first[:min]).to be_a(String)
        expect(salaries.salaries.first[:max]).to be_a(String)
      end
    end
  end
end
