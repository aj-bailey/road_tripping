require "rails_helper"

RSpec.describe "Sessions API Requests" do
  describe "Sessions Create" do
    before(:each) do
      User.create!(email: "whatever@example.com", password: "password", password_confirmation: "password")
    end

    context "Successful Request" do
      it "returns user json object with api_key when successfully authenticated" do
        params = {
          "email": "whatever@example.com",
          "password": "password",
        }

        post api_v1_sessions_path, params: params

        user_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)

        expect(user_response[:data].keys).to contain_exactly(:type, :id, :attributes)
        expect(user_response[:data][:type]).to eq("users")
        expect(user_response[:data][:id]).to be_a(String)

        expect(user_response[:data][:attributes].keys).to contain_exactly(:email, :api_key)
        expect(user_response[:data][:attributes][:email]).to be_a(String)
        expect(user_response[:data][:attributes][:api_key]).to be_a(String)
      end
    end

    context "Unsuccessful Request" do
      it "returns 401 serialized error when password incorrect with ambiguous message to what was incorrect" do
        params = {
          "email": "whatever@example.com",
          "password": "wrong_password",
        }

        post api_v1_sessions_path, params: params

        session_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(401)

        expect(session_response.keys).to contain_exactly(:message, :errors)
        expect(session_response[:message]).to eq("Invalid Credentials")
        expect(session_response[:errors]).to eq("Email or password is incorrect")
      end

      it "returns 401 serialized error when email doesn't exist with ambiguous message to what was incorrect" do
        params = {
          "email": "wrong_email@example.com",
          "password": "password",
        }

        post api_v1_sessions_path, params: params

        session_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(401)

        expect(session_response.keys).to contain_exactly(:message, :errors)
        expect(session_response[:message]).to eq("Invalid Credentials")
        expect(session_response[:errors]).to eq("Email or password is incorrect")
      end

      it "returns a 401 serialized error when no body included" do
        post api_v1_sessions_path

        session_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(401)

        expect(session_response.keys).to contain_exactly(:message, :errors)
        expect(session_response[:message]).to eq("Invalid Credentials")
        expect(session_response[:errors]).to eq("Email or password is incorrect")
      end
      
      it "returns a 401 serialized error when missing fields" do
        params = {
          "password": "password"
        }

        post api_v1_sessions_path, params: params

        session_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(401)

        expect(session_response.keys).to contain_exactly(:message, :errors)
        expect(session_response[:message]).to eq("Invalid Credentials")
        expect(session_response[:errors]).to eq("Email or password is incorrect")
      end
    end
  end
end