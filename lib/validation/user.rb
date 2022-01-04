# frozen_string_literal: true

module Validation
  class User
    include BCrypt
    EMAIL_REGEXP = /\A[\w!#$%&'*+\-\/=?^_`{|}~]{5,}+
                      @[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?(?:\.[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?)+\z/xi
    PASSWORD_REGEXP = /\A(?=.*[A-Z]+)(?=(.*\W){2,}).{8,20}\z/

    class << self
      # @param [String] value
      # @return [String, nil]
      def email(value)
        begin
          General.handle_regexp(value, EMAIL_REGEXP)
        rescue ArgumentError
          puts Style::Text.call(I18n.t('validation.email'), Style::TEXT_STYLES[:error])
          return
        end
        value.downcase
      end

      # @param [String] value
      # @return [Password, nil]
      def password(value)
        begin
          General.handle_regexp(value, PASSWORD_REGEXP)
        rescue ArgumentError
          puts Style::Text.call(I18n.t('validation.password'), Style::TEXT_STYLES[:error])
          return
        end
        BCrypt::Password.create(value)
      end
    end
  end
end
