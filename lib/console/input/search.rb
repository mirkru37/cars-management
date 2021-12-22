# frozen_string_literal: true

module Input
  class Search
    RULES = [Models::SearchRule.new('make'), Models::SearchRule.new('model'),
             Models::SearchRule.year('year_from'), Models::SearchRule.year('year_to'),
             Models::SearchRule.price('price_from'), Models::SearchRule.price('price_to')].freeze
    SORT_BY = %w[price date_added].freeze
    SORT_ORDER = %w[asc desc].freeze

    class << self
      def rules
        rules = RULES.map { :clone }
        res = Input::General.param(rules, message: I18n.t('input.request.rules'))
        res.delete_if do |rule|
          rule.value.to_s.strip.empty?
        end
      end

      def sort
        sort_by = Input::General.option(SORT_BY, default: 'date_added', message: I18n.t('input.request.sort_option'))
        sort_order = Input::General.option(SORT_ORDER, default: 'desc', message: I18n.t('input.request.sort_order'))
        puts "#{I18n.t('actions.chosen')} #{I18n.t('attributes.sort_option').downcase}: #{sort_by} " \
             "#{I18n.t('attributes.sort_order').downcase}: #{sort_order}"
        [sort_by, sort_order]
      end
    end
  end
end
