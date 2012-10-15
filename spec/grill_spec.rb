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
    Grill.home.should == "#{ENV["GRILL_HOME"]}/.grill"
  end

  # cannot use `context` because test will be broken
  # I don't know why but maybe that `context` require Bundler
  it "#implant by String" do
    cleanroom do
      defined?(Bundler).should be_nil
      defined?(Dummy).should be_nil
      defined?(DummyGit).should be_nil

      Grill.implant(<<-GEM)
        gem "bundler"
        gem "dummy", :path => "#{File.expand_path(".././support", __FILE__)}"
        gem "dummy_git", :git => "file://#{File.expand_path(".././support/dummy_git", __FILE__)}"
      GEM
      defined?(Bundler).should_not be_nil
      defined?(Dummy).should_not be_nil
      defined?(DummyGit).should_not be_nil
    end
  end

  it "#implant by Symbol" do
    cleanroom do
      name = :test
      File.open("#{Grill.home}/#{name}", "w") do |f|
        f.puts <<-GEM
          gem "dummy", :path => "#{File.expand_path(".././support", __FILE__)}"
          gem "dummy2", :path => "#{File.expand_path(".././support", __FILE__)}"
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
      gem "dummy", :path => "#{File.expand_path(".././support", __FILE__)}"
      FOO
      gem "dummy2", :path => "#{File.expand_path(".././support", __FILE__)}"
      BAR

      defined?(Dummy).should_not be_nil
      defined?(Dummy2).should_not be_nil
    end
  end

  it "separete Gemfile different contants" do
    Grill.implant(<<-GEM)
      gem "bundler"
    GEM
    Dir.glob("#{Grill.home}/*-*").length.should == 2 # Gemfile and Gemfile.lock

    Grill.implant(<<-GEM)
      gem "dummy", :path => "#{File.expand_path(".././support", __FILE__)}"
    GEM
    Dir.glob("#{Grill.home}/*-*").length.should == 4
  end
end
