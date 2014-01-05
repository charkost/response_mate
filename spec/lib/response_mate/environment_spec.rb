# coding: utf-8

require 'spec_helper'

shared_examples_for 'environment_file' do
  context "when file cannot be read" do
  end

  context "when file can be read" do
    context "when environment file is empty" do
      before do
        f = File.new(environment_file_name, 'w')
        f.close
      end

      it "assigns @env to empty hash" do
        subject.new(environment_file_name).env.should == {}
      end
    end

    context "when environment file is a valid yml" do
      before do
        f = File.open(environment_file_name, 'w')
        f.write('some_key: some_value')
        f.close
      end
      it "assigns @env" do
        subject.new(environment_file_name).env.should ==
          { 'some_key' => 'some_value' }
      end
    end
  end
end

describe ResponseMate::Environment, fakefs: true do
  subject { ResponseMate::Environment }

  describe '.initialize' do
    context "when no filename is provided" do
      context "when default file exists" do
        let(:environment_file_name) do
          ResponseMate.configuration.environment
        end

        it_behaves_like 'environment_file'
      end

      context "when default file does not exist" do
        it "assings @env to empty hash" do
          subject.new(nil).env.should == {}
        end
      end
    end

    context "when filename is provided" do
      context "when file does not exist" do
      end

      context "when file exists" do
      end
    end
  end
end
