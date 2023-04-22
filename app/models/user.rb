class User < ApplicationRecord
  validates :email, uniqueness: true,
                    presence: true,
                    format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  validates_presence_of :password

  has_secure_password

  before_save :generate_unique_api_key

  private
    def generate_unique_api_key
      api_key = SecureRandom.urlsafe_base64

      while find_user_by_api_key(api_key)
        api_key = SecureRandom.urlsafe_base64
      end

      self.api_key = api_key
    end

    def find_user_by_api_key(api_key)
      User.find_by(api_key: api_key)
    end
end
