# -- coding: utf-8

require "pp"
require File.expand_path("../../lib/grill", __FILE__)
require "rubygems"
require "rspec-expectations"
require "rspec/matchers/built_in/be"

RSpec.configure do |config|
  # Bundler is a singleton, so we must isolate each test processes
  def cleanroom(&block)
    pending "unsupported `fork`" unless 
    pid = fork { block.call }
    Process.waitall
  end
end
