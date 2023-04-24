require "rails_helper"

RSpec.describe Salaries do
  describe "#instance methods" do
    let(:facade) { SalariesFacade.new(destination: "chicago") }
    let(:salaries) { VCR.use_cassette("Chicago Salaries") { facade.salaries_details } }

    describe "#initialize" do
      it "exists" do
        expect(salaries).to be_a(Salaries)
      end

      it "has readable attributes" do
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
