# frozen_string_literal: true

module Input
  class User
    class << self
      def log_in
        email, password = Input::General.param([Models::Inputable.new('email'),
                                                Models::Inputable.new('password')], message: nil)
        Models::User.new(email.value, password.value)
      end

      # @return [Models::User]
      def sign_up(database)
        email = create_email.value # nil if invalid
        if !email.nil? && Validation::User.exist?(email, database)
          puts Style::Text.call(I18n.t('errors.user_exist'), Style::TEXT_STYLES[:error])
          email = nil # return
          # return sign_up(database)
        end
        return if email.nil?

        password = create_password.value # nil if invalid
        return if password.nil?

        Models::User.new(email, password)
      end

      private

      def create_email
        Input::General.param([Models::Inputable.new('email',
                                                    Validation::User.method(:email))], message: nil).first
      end

      # @return [Array<Inputable>]
      def create_password
        Input::General.param([Models::Inputable.new('password',
                                                    Validation::User.method(:password))], message: nil).first
      end
    end
  end
end
