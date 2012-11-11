require "digest/md5"
require "fileutils"
require "grill/version"

module Grill
  class << self

    def home
      home = "#{ENV["GRILL_HOME"] || ENV["HOME"] || "."}/.grill"
      unless File.directory?(home)
        FileUtils.mkdir_p(home)
      end
      home
    end

    def gemfile_path(gems)
      fullpath = File.expand_path($0)
      filename = "#{Digest::MD5.hexdigest(fullpath)}-#{Digest::MD5.hexdigest(gems)}"
      path = File.join(home, ruby, filename)
      dir = File.dirname(path)
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      path
    end

    def implant(*args)
      gems = ""
      args.each do |arg|
        if arg.class == Symbol
          gems << File.read(File.join(home, arg.to_s))
        else
          gems << arg
        end
        gems << "\n"
      end

      gemfile = gemfile_path(gems)
      tmp = File.open(gemfile, "w")
      tmp.puts gems
      tmp.close
      ENV["BUNDLE_GEMFILE"] = tmp.path

      gemdir = File.join(home, ruby)
      unless system(%Q!bundle check --gemfile "#{gemfile}" --path "#{gemdir}" > #{File::NULL}!)
        puts "missing gems found. will install them"
        system(%Q!bundle install --gemfile "#{gemfile}" --path "#{gemdir}"!)
        puts "gems are installed."
      end

      require "bundler/setup"
      Bundler.require
    end

    private
    def ruby
      "#{defined?(RUBY_ENGINE) ? RUBY_ENGINE : "ruby18"}-#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
    end
  end
end
