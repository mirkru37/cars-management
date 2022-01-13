# frozen_string_literal: true

require './lib/autoload'

app = App.new
Output::Menu.main(app: app)
