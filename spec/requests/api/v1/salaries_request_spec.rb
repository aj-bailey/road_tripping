require "rails_helper"

RSpec.describe "Salaries API Request" do
  describe "Salaries Create" do
    context "Successful Request" do
      it "returns salary JSON object of salaries information for a specified location" do
        VCR.use_cassette("Chicago Salaries") { post api_v1_salaries_index_path(destination: "chicago") }

        salaries_response = JSON.parse(response.body, symbolize_names: true)
        binding.pry
        expect(response).to be_successful

        expect(salaries_response[:data].keys).to contain_exactly(:id, :type, :attributes)
        expect(salaries_response[:data][:id]).to eq(nil)
        expect(salaries_response[:data][:type]).to eq("salaries")
        
        expect(salaries_response[:data][:attributes]).to contain_exactly(:destination, :forecast, :salaries)
        expect(salaries_response[:data][:attributes][:destination]).to eq("chicago")

        expect(salaries_response[:data][:attributes][:forecast]).to contain_exactly(:summary, :temperature)
        expect(salaries_response[:data][:attributes][:forecast][:summary]).to eq("Cloudy?")
        expect(salaries_response[:data][:attributes][:forecast][:temperature]).to eq("83 F?")

        expect(salaries_response[:data][:attributes][:salaries].count).to eq(1)
        expect(salaries_response[:data][:attributes][:salaries].first.keys).to contain_exactly(:title, :min, :max)
        expect(salaries_response[:data][:attributes][:salaries].first[:title]).to eq("Data Analyst")
        expect(salaries_response[:data][:attributes][:salaries].first[:min]).to eq("money")
        expect(salaries_response[:data][:attributes][:salaries].first[:max]).to eq("money")
      end
    end

    context "Unsuccessful Request" do

    end
  end
end