# frozen_string_literal: true

# TODO: add exit availability in input methods, rework general input (any), rework style behaviour (few types of text (header, important, message, input etc.))
# TODO: make kwargs ==> app

require './lib/autoload'

app = App.new
Output::Menu.main(app: app)
