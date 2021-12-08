# frozen_string_literal: true

class I18nConfig
  def self.init
    I18n.load_path << Dir["#{File.expand_path('config/locales')}/*.yml"]
    I18n.default_locale = :en
  end

  def self.choose_language(locales)
    locale = Input.option(locales, default: 'en', message: I18n.t('input.request.language'))
    I18n.locale = locale
  end
end
