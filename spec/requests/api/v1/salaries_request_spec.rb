require "rails_helper"

RSpec.describe "Salaries API Request" do
  describe "Salaries Create" do
    context "Successful Request" do
      it "returns salary JSON object of salaries information for a specified location" do
        VCR.use_cassette("Chicago Salaries") { post api_v1_salaries_path(destination: "chicago") }

        salaries_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful

        expect(salaries_response[:data].keys).to contain_exactly(:id, :type, :attributes)
        expect(salaries_response[:data][:id]).to eq(nil)
        expect(salaries_response[:data][:type]).to eq("salaries")

        expect(salaries_response[:data][:attributes].keys).to contain_exactly(:destination, :forecast, :salaries)
        expect(salaries_response[:data][:attributes][:destination]).to eq("chicago")

        expect(salaries_response[:data][:attributes][:forecast].keys).to contain_exactly(:summary, :temperature)
        expect(salaries_response[:data][:attributes][:forecast][:summary]).to eq("Partly cloudy")
        expect(salaries_response[:data][:attributes][:forecast][:temperature]).to eq("46 F")

        expect(salaries_response[:data][:attributes][:salaries].count).to eq(7)
        expect(salaries_response[:data][:attributes][:salaries].first.keys).to contain_exactly(:title, :min, :max)
        expect(salaries_response[:data][:attributes][:salaries].first[:title]).to eq("Data Analyst")
        expect(salaries_response[:data][:attributes][:salaries].first[:min]).to eq("$46,898.19")
        expect(salaries_response[:data][:attributes][:salaries].first[:max]).to eq("$67,929.19")
      end
    end

    context "Unsuccessful Request" do
      it "returns 400 serialized error when missing destination params" do
        post api_v1_salaries_path(destination: nil)

        salaries_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful

        expect(salaries_response.keys).to contain_exactly(:message, :errors)
        expect(salaries_response[:message]).to eq("param is missing or the value is empty")

        expect(salaries_response[:errors].count).to eq(1)
        expect(salaries_response[:errors].first).to eq("Missing destination")
      end

      it "returns 400 serialized error when no params submitted" do
        post api_v1_salaries_path

        salaries_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful

        expect(salaries_response.keys).to contain_exactly(:message, :errors)
        expect(salaries_response[:message]).to eq("param is missing or the value is empty")

        expect(salaries_response[:errors].count).to eq(1)
        expect(salaries_response[:errors].first).to eq("Missing destination")
      end

      it "returns 404 serialized error when unable to find destination" do
        VCR.use_cassette("Destination Not Found") { post api_v1_salaries_path(destination: "avon") }

        salaries_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful

        expect(salaries_response.keys).to contain_exactly(:message, :errors)
        expect(salaries_response[:message]).to eq("your query could not be completed")

        expect(salaries_response[:errors].count).to eq(1)
        expect(salaries_response[:errors].first).to eq("Destination not found")
      end
    end
  end
end
