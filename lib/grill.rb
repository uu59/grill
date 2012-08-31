require "tempfile"
require "digest/md5"
require "fileutils"
require "grill/version"

module Grill
  class << self
    attr_reader :gemfile

    HOME = "#{ENV["HOME"] || "."}/.grill"
    unless File.directory?(HOME)
      FileUtils.mkdir(HOME)
    end

    def implant(gems)
      fullpath = File.expand_path($0)
      gemfile = "#{HOME}/#{Digest::MD5.hexdigest(fullpath)}"
      @gem = gems
      tmp = File.open(gemfile, "w")
      tmp.puts @gem
      tmp.close
      ENV["BUNDLE_GEMFILE"] = tmp.path

      unless system(%Q!bundle check --gemfile "#{gemfile}" --path #{HOME}/gems > #{File::NULL}!)
        puts "missing gems found. will install them"
        system(%Q!bundle install --gemfile "#{gemfile}" --path "#{HOME}/gems"!)
        puts "gems are installed."
      end
      require "bundler/setup"
      Bundler.require
    end
  end
end
