# frozen_string_literal: true

module Input
  class User
    class << self
      def log_in
        email, password = Input::General.param([Models::Inputable.new('email'),
                                                Models::Inputable.new('password')])
        Models::User.new(email.value, password.value)
      end

      # @return [Models::User]
      def sign_up(database)
        email = valid_email.value
        return if email.nil?

        if Validation::User.exist?(email, database)
          puts Style::Text.call(I18n.t('errors.user_exist'), Style::TEXT_STYLES[:error])
          return
        end
        password = valid_password.value
        return if password.nil?

        Models::User.new(email, password)
      end

      private

      def valid_email
        Input::General.param([Models::Inputable.new('email',
                                                    Validation::User.method(:email))]).first
      end

      # @return [Array<Inputable>]
      def valid_password
        Input::General.param([Models::Inputable.new('password',
                                                    Validation::User.method(:password))]).first
      end
    end
  end
end
