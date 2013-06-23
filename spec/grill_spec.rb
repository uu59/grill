# -- coding: utf-8

require "spec_helper"

describe Grill do
  before(:all) do
    ENV["GRILL_HOME"] = File.expand_path("../tmp", __FILE__)
  end

  after(:each) do
    FileUtils.rm_rf(ENV["GRILL_HOME"])
  end

  it "#home" do
    Grill.home.should match %r!^#{ENV["GRILL_HOME"]}/.grill!
  end

  # cannot use `context` because test will be broken
  # I don't know why but maybe that `context` require Bundler
  it "#implant by String" do
    cleanroom do
      defined?(Dummy).should be_nil

      Grill.implant(<<-GEM)
        gem "dummy", :path => "#{File.expand_path(".././support/dummy", __FILE__)}"
      GEM
      defined?(Dummy).should_not be_nil
    end
  end

  it "#implant by Symbol" do
    cleanroom do
      name = :test
      File.open("#{Grill.home}/#{name}", "w") do |f|
        f.puts <<-GEM
          gem "dummy", :path => "#{File.expand_path(".././support/dummy", __FILE__)}"
          gem "dummy2", :path => "#{File.expand_path(".././support/dummy2", __FILE__)}"
        GEM
      end
      defined?(Dummy).should be_nil
      defined?(Dummy2).should be_nil

      Grill.implant name
      defined?(Dummy).should_not be_nil
      defined?(Dummy2).should_not be_nil
    end
  end

  it "#implant multiple" do
    cleanroom do
      defined?(Dummy).should be_nil
      defined?(Dummy2).should be_nil

      Grill.implant <<-FOO, <<-BAR
      gem "dummy", :path => "#{File.expand_path(".././support/dummy", __FILE__)}"
      FOO
      gem "dummy2", :path => "#{File.expand_path(".././support/dummy2", __FILE__)}"
      BAR

      defined?(Dummy).should_not be_nil
      defined?(Dummy2).should_not be_nil
    end
  end

  it "separete Gemfile different contants" do
    gemfile1 = 'gem "hogehoge"'
    file1 = Grill.gemfile_path(gemfile1)

    gemfile2 = <<-GEM
      gem "dummy", :path => "#{File.expand_path(".././support/dummy", __FILE__)}"
    GEM
    file2 = Grill.gemfile_path(gemfile2)

    file1.should_not == file2
  end
end
