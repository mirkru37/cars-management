# frozen_string_literal: true

module Validation
  class User
    include BCrypt
    # rubocop:disable Layout/LineLength
    EMAIL_REGEXP = /\A[\w!#$%&'*+\-\/=?^_`{|}~]{5,}+@[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?(?:\.[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?)+\z/i
    PASSWORD_REGEXP = /\A(?=.*[A-Z]+)(?=(.*\W){2,}).{8,20}\z/
    # rubocop:enable Layout/LineLength

    class << self
      # @param [String] email
      # @param [Database] database
      def exist?(email, database)
        users = database.load('users', [Models::User, BCrypt::Password])
        users.any? do |user|
          user.email == email
        end
      end

      # @param [String] value
      # @return [String, nil]
      def email(value)
        begin
          General.handle_regexp(value, EMAIL_REGEXP)
        rescue ArgumentError
          puts Style::Text.call(I18n.t('validation.email'), Style::TEXT_STYLES[:error])
          return nil
        end
        value.downcase
      end

      # @param [Models::User] user
      # @param [Database] database
      def match?(user, database)
        pass = user.password
        user.hash_pass
        users = database.load('users', [Models::User, BCrypt::Password])
        users.any? do |db_user|
          db_user.email == user.email && db_user.password == pass
        end
      end

      # @param [String] value
      # @return [Password, nil]
      def password(value)
        begin
          General.handle_regexp(value, PASSWORD_REGEXP)
        rescue ArgumentError
          puts Style::Text.call(I18n.t('validation.password'), Style::TEXT_STYLES[:error])
          return nil
        end
        BCrypt::Password.create(value)
      end
    end
  end
end
