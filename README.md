# Grill

<a href="http://en.wikipedia.org/wiki/File:Paul_Wall.jpg"><img src="http://upload.wikimedia.org/wikipedia/commons/9/99/Paul_Wall.jpg" /></a>

<http://en.wikipedia.org/wiki/Grill_(jewelry)>

Implant Gemfile into your script.

## Installation

    $ gem install grill

## Usage

    #!ruby

    require "grill"

    p defined?(Rack) # => nil

    Grill.implant <<-GEMFILE
      source :rubygems
      gem "rack"
      gem "foo", :path => "/path/to/lib"
      gem "bar", :git => "file:///path/to/repo"
    GEMFILE

    p defined?(Rack) # => "constant"
