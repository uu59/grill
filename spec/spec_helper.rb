# -- coding: utf-8

require "pp"
require File.expand_path("../../lib/grill", __FILE__)
require "rubygems"
require "rspec/expectations"
require "rspec/matchers/built_in/be"

RSpec.configure do |config|
  # Bundler is a singleton, so we must isolate each test processes
  def cleanroom(&block)
    pending "unsupported `fork`" unless Process.respond_to?(:fork)
    Process.fork do
      block.call
    end
    Process.waitall
    $?.to_i.should == 0
  end
end
