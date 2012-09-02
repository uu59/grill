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

  it "#implant" do
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
