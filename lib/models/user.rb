# frozen_string_literal: true

module Models
  class User
    attr_reader :email, :password

    # @param [UserData] email
    # @param [BCrypt::Password, String] password
    def initialize(email, password)
      @email = email
      @password = password
    end

    def hash_pass
      @password = BCrypt::Password.create(@password)
    end
  end
end
