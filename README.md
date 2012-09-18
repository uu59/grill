# Grill

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

# Compatibility of Gemfile

It is completely compatible (you installed version) Bundler's Gemfile so you can use [full spec of it](http://gembundler.com/gemfile.html) for version fixation, `:require`, `:path`, etc.

## When use this?

Grill is useful for your disposable scripts. Do you want to do that create directory and put Gemfile into it and `bundle install; bundle exec foo.rb` for *disposable* scripts?

