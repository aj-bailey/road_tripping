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
      it "returns 400 serialized error when passwords don't match" do
        params = { 
                   "email": "whatever@example.com",
                   "password": "password",
                   "password_confirmation": "not_password"
                 }

        post api_v1_users_path, params: params
        
        user_response = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to_not be_successful
        expect(response.status).to eq(400)

        expect(user_response[:message]).to eq("Validation failed")
        expect(user_response[:errors].count).to eq(1)
        expect(user_response[:errors][0]).to eq("Password confirmation doesn't match Password")
      end

      it "returns a 400 serialized error when email is already taken" do
        params = { 
          "email": "whatever@example.com",
          "password": "password",
          "password_confirmation": "password"
        }
        
        User.create!(params)

        post api_v1_users_path, params: params

        user_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)

        expect(user_response[:message]).to eq("Validation failed")
        expect(user_response[:errors].count).to eq(1)
        expect(user_response[:errors][0]).to eq("Email has already been taken")
      end

      it "returns a 400 serialized error when missing fields" do
        params = { 
                   "password": "password",
                   "password_confirmation": "password"
                 }

        post api_v1_users_path, params: params

        user_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)

        expect(user_response[:message]).to eq("Validation failed")
        expect(user_response[:errors].count).to eq(2)
        expect(user_response[:errors][0]).to eq("Email can't be blank")
        expect(user_response[:errors][1]).to eq("Email is invalid")
      end

      it "returns a 400 serialied error when no body included" do
        post api_v1_users_path

        user_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)

        expect(user_response[:message]).to eq("Validation failed")
        expect(user_response[:errors].count).to eq(4)
        expect(user_response[:errors][0]).to eq("Email can't be blank")
        expect(user_response[:errors][1]).to eq("Email is invalid")
        expect(user_response[:errors][2]).to eq("Password can't be blank")
        expect(user_response[:errors][3]).to eq("Password can't be blank")
      end
    end
  end
end