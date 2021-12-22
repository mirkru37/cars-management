# frozen_string_literal: true

class I18nConfig
  class << self
    def init
      I18n.load_path << Dir["#{File.expand_path('config/locales')}/*.yml"]
      I18n.default_locale = :en
    end

    # def choose_language(locales)
    #   locale = Input::General.option(locales, default: 'en', message: I18n.t('input.request.language'))
    #   I18n.locale = locale
    # end
  end
end
