# -- coding: utf-8

require "spec_helper"

describe Grill do
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
end
