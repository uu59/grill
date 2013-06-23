#!/usr/bin/env ruby
# -- coding: utf-8

require "rubygems"
require "rspec"
RSpec::Core::Runner.run [File.expand_path("../../spec", __FILE__), "-c"]
