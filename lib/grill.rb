require "tempfile"
require "digest/md5"
require "fileutils"
require "grill/version"

module Grill
  class << self
    attr_reader :gemfile

    def home
      home = "#{ENV["GRILL_HOME"] || ENV["HOME"] || "."}/.grill"
      unless File.directory?(home)
        FileUtils.mkdir_p(home)
      end
      home
    end

    def implant(gems)
      fullpath = File.expand_path($0)
      gemfile = "#{home}/#{Digest::MD5.hexdigest(fullpath)}"
      @gem = gems
      tmp = File.open(gemfile, "w")
      tmp.puts @gem
      tmp.close
      ENV["BUNDLE_GEMFILE"] = tmp.path

      unless system(%Q!bundle check --gemfile "#{gemfile}" --path #{home}/gems > #{File::NULL}!)
        puts "missing gems found. will install them"
        system(%Q!bundle install --gemfile "#{gemfile}" --path "#{home}/gems"!)
        puts "gems are installed."
      end
      require "bundler/setup"
      Bundler.require
    end
  end
end
