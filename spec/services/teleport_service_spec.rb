require "rails_helper"

RSpec.describe TeleportService do
  describe "#instance methods" do
    before(:each) do
      @service = TeleportService.new(destination: "chicago")
    end

    describe "#initialize" do
      it "exists" do
        expect(@service).to be_a(TeleportService)
      end
    end

    describe "#salaries" do
      it "returns salary information" do
        VCR.use_cassette("Chicago Salaries") { @salaries_information = @service.salaries_information }

        data_analyst_salary = @salaries_information[:salaries].find { |salary| salary[:job][:title] == "Data Analyst" }

        expect(data_analyst_salary[:salary_percentiles][:percentile_25]).to be_a(Float)
        expect(data_analyst_salary[:salary_percentiles][:percentile_75]).to be_a(Float)
      end
    end
  end
end
