require "rails_helper"

RSpec.describe "Users API Requests" do
  describe "Users Create" do
    context "Sucessful Request" do
      it "creates a new user" do
        params = { 
                   "email": "whatever@example.com",
                   "password": "password",
                   "password_confirmation": "password"
                 }

        post api_v1_users_path, params: params

        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful

        expect(user_response[:data].keys).to contain_exactly(:type, :id, :attributes)
        expect(user_response[:data][:type]).to eq("users")
        expect(user_response[:data][:id]).to be_a(String)

        expect(user_response[:data][:attributes].keys).to contain_exactly(:email, :api_key)
        expect(user_response[:data][:attributes][:email]).to be_a(String)
        expect(user_response[:data][:attributes][:api_key]).to be_a(String)
      end
    end

    context "Unsuccessful Request" do

    end
  end
end