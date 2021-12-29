# frozen_string_literal: true

module Models
  class User
    attr_accessor :email, :password

    # @param [UserData] email
    # @param [BCrypt::Password, String] password
    def initialize(email = '', password = '')
      @email = email
      @password = password
    end

    # @param [Database] database
    def exist?(database)
      users = database.load('users', [Models::User, BCrypt::Password])
      users.any? do |user|
        user.email == email
      end
    end

    # @param [Database] database
    def match?(database)
      pass = password
      users = database.load('users', [Models::User, BCrypt::Password])
      users.any? do |db_user|
        db_user.email == email && db_user.password == pass
      end
    end
  end
end
