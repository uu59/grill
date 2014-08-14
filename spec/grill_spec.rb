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

  describe "#implant" do
    it "by String" do
      cleanroom do
        self.should_receive(:require).with("dummy")

        Grill.implant(<<-GEM)
          gem "dummy", :path => "#{File.expand_path(".././support/dummy", __FILE__)}"
        GEM
      end
    end

    it "multiple" do
      cleanroom do
        self.should_receive(:require).with("dummy")
        self.should_receive(:require).with("dummy2")

        Grill.implant <<-FOO, <<-BAR
        gem "dummy", :path => "#{File.expand_path(".././support/dummy", __FILE__)}"
        FOO
        gem "dummy2", :path => "#{File.expand_path(".././support/dummy2", __FILE__)}"
        BAR
      end
    end

  end

  describe "#build_gemfile" do

    it "auto completion `source` if lacked" do
      gemfile = Grill.build_gemfile "gem 'rack'"
      gemfile["source"].should_not be_nil
      gemfile["https://rubygems.org"].should_not be_nil
    end

    it "can receive Symbol" do
      name = :test
      gemfile = <<-GEM
        source "https://rubygems.org"
        gem "dummy", :path => "#{File.expand_path(".././support/dummy", __FILE__)}"
        gem "dummy2", :path => "#{File.expand_path(".././support/dummy2", __FILE__)}"
      GEM

      File.open("#{Grill.home}/#{name}", "w") do |f|
        f.write gemfile
      end

      # strip \n for normalize
      Grill.build_gemfile(name).rstrip.should == gemfile.rstrip
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
