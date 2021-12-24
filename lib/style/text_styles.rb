# frozen_string_literal: true

module Style
  TEXT_STYLES = {
    error: {
      color: :light_red,
      typeface: :bold
    },
    header: {
      color: :light_cyan,
      typeface: :bold
    },
    highlight: {
      color: :light_cyan
    },
    hint: {
      color: :cyan,
      typeface: :italic
    },
    important: {
      color: :light_green,
      typeface: :bold
    },
    input: {
      color: :light_white
    },
    title: {
      color: :light_cyan,
      typeface: :bold
    }
  }.freeze
end
