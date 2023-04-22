require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }

    it "should validate that it's a properly formatted email" do
      john = User.new(email: "jsmith@gmail.com", password: "password", api_key: "example_key")
      expect(john.valid?).to be(true)

      john = User.new(email: "fasd324223", password: "password", api_key: "example_key")
      expect(john.valid?).to be(false)
    end
  end
end
