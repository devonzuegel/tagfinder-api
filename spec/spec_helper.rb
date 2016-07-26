require 'bundler/setup'
require 'rspec'
require 'rack/test'

require 'awesome_print'
require 'colorize'

require './lib/tagfinder/app'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.filter_run_excluding skip: true

  # Tag examples with `:focus` to run them individually. When
  # nothing is tagged with `:focus`, all examples get run.
  config.filter_run focus: ENV['CI'] != 'true'
  config.run_all_when_everything_filtered = true

  config.around(:each) { |test| Timeout.timeout(320, &test) }
end
