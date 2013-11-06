require "simplecov"
require "coveralls"
require "lita-gitcamp"
require "lita/rspec"
require 'webmock/rspec'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start { add_filter "/spec/" }

WebMock.disable_net_connect!