require 'spec_helper'

describe Guard::CMake::Runner do

  subject { described_class.new }
  let(:cmake) { subject.instance_variable_get(:@cmake) }
  let(:default_options) { { out_of_src_build: true, build_dir: 'build' } }

  describe "#initialize" do

    context "with no options" do
      it "sets default options" do
        runner = described_class.new
        expect(runner.instance_variable_get(:@options)[:out_of_src_build]).to be_true
        expect(runner.instance_variable_get(:@options)[:build_dir]).to eq "build"
      end

      it 'instantiates a new CMakeRunner' do
        expect(Guard::CMake::CMakeRunner).to receive(:new).with(default_options)
        described_class.new
      end
    end
  end

  describe "#run_all" do
    context "with default options" do
      it "builds the project directory" do
        expect(subject).to receive(:run).with(["build"])
        subject.run_all
      end
    end
  end

  describe "#run" do
    it "generates makefiles in the given directories" do
      # cmake.stub(cmake
      # expect(
    end
  end

end
