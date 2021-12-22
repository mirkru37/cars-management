# frozen_string_literal: true

require './lib/autoload'

app = App.new
Output::Menu.show(App::MAIN_MENU, app: app)
