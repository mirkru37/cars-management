# frozen_string_literal: true

module Operations
  class I18nConfig
    class << self
      def init
        I18n.load_path << Dir["#{File.expand_path('config/locales')}/*.yml"]
        I18n.default_locale = :en
      end

      def choose_language(locales)
        locale = Console::Input.option(locales, default: 'en', message: I18n.t('input.request.language'))
        I18n.locale = locale
      end
    end
  end
end
