# Use bundler/inline instead

```console
require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  gem "rack"
end

p defined?(Rack) # => "constant"
```

# Grill

[![Build Status](https://travis-ci.org/uu59/grill.svg?branch=master)](https://travis-ci.org/uu59/grill)
[![Code Climate](https://codeclimate.com/github/uu59/grill/badges/gpa.svg)](https://codeclimate.com/github/uu59/grill)
[![Gem Version](https://badge.fury.io/rb/grill.svg)](http://badge.fury.io/rb/grill)

<a href="http://en.wikipedia.org/wiki/File:Paul_Wall.jpg"><img src="http://upload.wikimedia.org/wikipedia/commons/9/99/Paul_Wall.jpg" /></a>

<http://en.wikipedia.org/wiki/Grill_(jewelry)>

Implant Gemfile into your script.

## Installation

    $ gem install grill

If you want to uninstall gems installed by Grill, delete `$HOME/.grill` directory.

## Usage

    #!ruby

    require "grill"

    p defined?(Rack) # => nil

    Grill.implant <<-GEMFILE
      source :rubygems
      gem "rack"
    GEMFILE

    p defined?(Rack) # => "constant"

Or, more handy way to use as below (since v0.2.1):

    $ cat $HOME/.grill/commontools
    source :rubygems
    gem "typhoeus"
    gem "nokogiri"
    gem "slop"

    $ cat scraper.rb
    require "grill"

    Grill.implant :commontools

    opts = Slop.parse do
      # ...
    end

You can multiple implant as below (since v0.3.0):

    # these args will be combined one file.
    # so if first arg define "source" and second is not, 
    # second arg's `gem` is affected by that

    Grill.implant <<-FOO, <<-BAR, :commontools
      source :rubygems
      gem "typhoeus"
      gem "nokogiri"
    FOO
      gem "rack"
    BAR

    # You got typhoeus, nokogiri, rack, and :commontools

# Compatibility of Gemfile

It is completely compatible (you installed version) Bundler's Gemfile so you can use [full spec of it](http://gembundler.com/gemfile.html) for version fixation, `:require`, `:path`, etc.

## When use this?

Grill is useful for your disposable scripts. Do you want to do that create directory and put Gemfile into it and `bundle install; bundle exec foo.rb` for *disposable* scripts?

