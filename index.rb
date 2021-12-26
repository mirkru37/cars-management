# frozen_string_literal: true

# TODO: add exit availability in input methods, rework general input (any),

require './lib/autoload'

app = App.new
Output::Menu.main(app: app)
