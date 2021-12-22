# frozen_string_literal: true

class I18nConfig
  class << self
    def init
      I18n.load_path << Dir["#{File.expand_path('config/locales')}/*.yml"]
      I18n.default_locale = :en
    end
  end
end
