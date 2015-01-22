ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.require

# Load the application
require_relative '../app'
require 'rspec'

RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  config.formatter = :documentation#, :progress, :html, :textmate
end